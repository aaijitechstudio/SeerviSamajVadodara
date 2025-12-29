import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/post_model.dart';
import '../../../shared/data/firebase_service.dart';

// News controller provider (auto-disposing for better memory management)
final newsControllerProvider = NotifierProvider.autoDispose<NewsController, NewsState>(() {
  return NewsController();
});

// News state class
class NewsState {
  final bool isLoading;
  final String? error;
  final List<PostModel> news;
  final List<PostModel> announcements;
  final bool hasMore;
  final String? lastDocumentId;
  final String? category;
  final DateTime? fromDate;
  final DateTime? toDate;

  const NewsState({
    this.isLoading = false,
    this.error,
    this.news = const [],
    this.announcements = const [],
    this.hasMore = true,
    this.lastDocumentId,
    this.category,
    this.fromDate,
    this.toDate,
  });

  NewsState copyWith({
    bool? isLoading,
    String? error,
    List<PostModel>? news,
    List<PostModel>? announcements,
    bool? hasMore,
    String? lastDocumentId,
    String? category,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      news: news ?? this.news,
      announcements: announcements ?? this.announcements,
      hasMore: hasMore ?? this.hasMore,
      lastDocumentId: lastDocumentId ?? this.lastDocumentId,
      category: category ?? this.category,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

// News controller
class NewsController extends AutoDisposeNotifier<NewsState> {
  @override
  NewsState build() {
    return const NewsState();
  }

  // Load news and announcements
  Future<void> loadNews() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final allPosts = await FirebaseService.getPostsPaginated(
        lastDocumentId: null,
        limit: 50,
      );

      // Filter announcements and regular news
      final announcements = allPosts.where((post) => post.isAnnouncement).toList();
      final news = allPosts.where((post) => !post.isAnnouncement).toList();

      state = state.copyWith(
        isLoading: false,
        news: news,
        announcements: announcements,
        hasMore: allPosts.length >= 50,
        lastDocumentId: allPosts.isNotEmpty ? allPosts.last.id : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Load more news (pagination)
  Future<void> loadMoreNews() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newPosts = await FirebaseService.getPostsPaginated(
        lastDocumentId: state.lastDocumentId,
        limit: 20,
      );

      if (newPosts.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      // Separate new posts into news and announcements
      final newAnnouncements = newPosts.where((post) => post.isAnnouncement).toList();
      final newNews = newPosts.where((post) => !post.isAnnouncement).toList();

      state = state.copyWith(
        isLoading: false,
        news: [...state.news, ...newNews],
        announcements: [...state.announcements, ...newAnnouncements],
        lastDocumentId: newPosts.last.id,
        hasMore: newPosts.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Filter news by category
  void filterByCategory(String? category) {
    state = state.copyWith(category: category);
  }

  // Filter news by date range
  void filterByDateRange(DateTime? fromDate, DateTime? toDate) {
    state = state.copyWith(fromDate: fromDate, toDate: toDate);
  }

  // Clear filters
  void clearFilters() {
    state = state.copyWith(
      category: null,
      fromDate: null,
      toDate: null,
    );
  }

  // Get filtered news
  List<PostModel> getFilteredNews() {
    var filteredNews = state.news;

    // Apply category filter
    if (state.category != null && state.category!.isNotEmpty) {
      // This would require adding category field to PostModel
      // For now, we'll filter by content keywords
      filteredNews = filteredNews.where((post) {
        return post.content.toLowerCase().contains(state.category!.toLowerCase());
      }).toList();
    }

    // Apply date range filter
    if (state.fromDate != null) {
      filteredNews = filteredNews.where((post) {
        return post.createdAt.isAfter(state.fromDate!) ||
               post.createdAt.isAtSameMomentAs(state.fromDate!);
      }).toList();
    }

    if (state.toDate != null) {
      filteredNews = filteredNews.where((post) {
        return post.createdAt.isBefore(state.toDate!) ||
               post.createdAt.isAtSameMomentAs(state.toDate!);
      }).toList();
    }

    return filteredNews;
  }

  // Get filtered announcements
  List<PostModel> getFilteredAnnouncements() {
    var filteredAnnouncements = state.announcements;

    // Apply category filter
    if (state.category != null && state.category!.isNotEmpty) {
      filteredAnnouncements = filteredAnnouncements.where((post) {
        return post.content.toLowerCase().contains(state.category!.toLowerCase());
      }).toList();
    }

    // Apply date range filter
    if (state.fromDate != null) {
      filteredAnnouncements = filteredAnnouncements.where((post) {
        return post.createdAt.isAfter(state.fromDate!) ||
               post.createdAt.isAtSameMomentAs(state.fromDate!);
      }).toList();
    }

    if (state.toDate != null) {
      filteredAnnouncements = filteredAnnouncements.where((post) {
        return post.createdAt.isBefore(state.toDate!) ||
               post.createdAt.isAtSameMomentAs(state.toDate!);
      }).toList();
    }

    return filteredAnnouncements;
  }

  // Get pinned announcements
  List<PostModel> get pinnedAnnouncements {
    return state.announcements.where((post) => post.isPinned).toList();
  }

  // Get recent news (last 7 days)
  List<PostModel> get recentNews {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return state.news.where((post) => post.createdAt.isAfter(weekAgo)).toList();
  }

  // Get trending news (most liked in last 30 days)
  List<PostModel> get trendingNews {
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    final recentNews = state.news.where((post) => post.createdAt.isAfter(monthAgo)).toList();

    // Sort by likes count
    recentNews.sort((a, b) => b.likesCount.compareTo(a.likesCount));
    return recentNews.take(10).toList();
  }

  // Refresh news
  Future<void> refreshNews() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      news: [],
      announcements: [],
      hasMore: true,
      lastDocumentId: null,
    );
    await loadNews();
  }

  // Add news item to local state
  void addNewsItem(PostModel post) {
    if (post.isAnnouncement) {
      final updatedAnnouncements = [post, ...state.announcements];
      state = state.copyWith(announcements: updatedAnnouncements);
    } else {
      final updatedNews = [post, ...state.news];
      state = state.copyWith(news: updatedNews);
    }
  }

  // Update news item in local state
  void updateNewsItem(PostModel updatedPost) {
    if (updatedPost.isAnnouncement) {
      final updatedAnnouncements = state.announcements.map((post) {
        return post.id == updatedPost.id ? updatedPost : post;
      }).toList();
      state = state.copyWith(announcements: updatedAnnouncements);
    } else {
      final updatedNews = state.news.map((post) {
        return post.id == updatedPost.id ? updatedPost : post;
      }).toList();
      state = state.copyWith(news: updatedNews);
    }
  }

  // Remove news item from local state
  void removeNewsItem(String postId) {
    final updatedNews = state.news.where((post) => post.id != postId).toList();
    final updatedAnnouncements = state.announcements.where((post) => post.id != postId).toList();

    state = state.copyWith(
      news: updatedNews,
      announcements: updatedAnnouncements,
    );
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}