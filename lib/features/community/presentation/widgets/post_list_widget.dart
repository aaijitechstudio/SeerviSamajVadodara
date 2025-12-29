import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../members/domain/models/user_model.dart';
import '../../../../shared/data/firebase_service.dart';
import '../screens/post_composer_screen.dart';
import 'post_item_widget.dart';

enum PostFilterType { all, admin, members }

class PostListWidget extends ConsumerStatefulWidget {
  final PostCategory? category;

  const PostListWidget({
    super.key,
    this.category,
  });

  @override
  ConsumerState<PostListWidget> createState() => _PostListWidgetState();
}

class _PostListWidgetState extends ConsumerState<PostListWidget> {
  final ScrollController _scrollController = ScrollController();
  List<PostModel> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _lastDocumentId;
  PostFilterType _selectedFilter = PostFilterType.all;
  Map<String, UserModel> _userCache =
      {}; // Cache for user data to check admin status

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading &&
        _hasMore) {
      _loadMorePosts();
    }
  }

  Future<void> _loadPosts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final postRepository = ref.read(postRepositoryProvider);

      if (postRepository == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Firebase is not initialized. Please restart the app.'),
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final result = widget.category != null
          ? await postRepository.getPostsByCategory(
              widget.category!,
              limit: 20,
            )
          : await postRepository.getPostsPaginated(
              limit: 20,
            );

      if (result.failure != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ErrorHandler.getUserFriendlyMessageFromFailure(
                  result.failure!)),
            ),
          );
        }
      } else if (result.data != null) {
        setState(() {
          _posts = result.data!;
          _hasMore = result.data!.length >= 20;
          if (result.data!.isNotEmpty) {
            _lastDocumentId = result.data!.last.id;
          }
        });
        // Load user data for filtering
        _loadUserDataForPosts();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading posts: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final postRepository = ref.read(postRepositoryProvider);

      if (postRepository == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Firebase is not initialized. Please restart the app.'),
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final result = widget.category != null
          ? await postRepository.getPostsByCategory(
              widget.category!,
              lastDocumentId: _lastDocumentId,
              limit: 20,
            )
          : await postRepository.getPostsPaginated(
              lastDocumentId: _lastDocumentId,
              limit: 20,
            );

      if (result.failure != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ErrorHandler.getUserFriendlyMessageFromFailure(
                  result.failure!)),
            ),
          );
        }
      } else if (result.data != null) {
        setState(() {
          _posts.addAll(result.data!);
          _hasMore = result.data!.length >= 20;
          if (result.data!.isNotEmpty) {
            _lastDocumentId = result.data!.last.id;
          } else {
            _hasMore = false;
          }
        });
        // Load user data for new posts
        _loadUserDataForPosts();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading more posts: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _posts = [];
      _lastDocumentId = null;
      _hasMore = true;
      _userCache.clear();
    });
    await _loadPosts();
  }

  Future<void> _loadUserDataForPosts() async {
    // Pre-load user data for all posts to enable filtering
    final postsToCheck =
        _posts.where((post) => !_userCache.containsKey(post.authorId)).toList();

    for (final post in postsToCheck) {
      try {
        final user = await FirebaseService.getUserData(post.authorId);
        if (user != null) {
          _userCache[post.authorId] = user;
        }
      } catch (e) {
        // Ignore errors, will use fallback
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  List<PostModel> _getFilteredPosts() {
    List<PostModel> filtered = _posts;

    // Apply filter
    if (_selectedFilter != PostFilterType.all) {
      filtered = _posts.where((post) {
        final isAdmin =
            _userCache[post.authorId]?.isAdmin ?? post.isAnnouncement;
        if (_selectedFilter == PostFilterType.admin) {
          return isAdmin;
        } else if (_selectedFilter == PostFilterType.members) {
          return !isAdmin;
        }
        return true;
      }).toList();
    }

    // Sort: Pinned admin posts first, then by date
    filtered.sort((a, b) {
      final aIsAdmin = _userCache[a.authorId]?.isAdmin ?? a.isAnnouncement;
      final bIsAdmin = _userCache[b.authorId]?.isAdmin ?? b.isAnnouncement;

      // Pinned admin posts first
      if (a.isPinned && aIsAdmin && !(b.isPinned && bIsAdmin)) return -1;
      if (b.isPinned && bIsAdmin && !(a.isPinned && aIsAdmin)) return 1;

      // Then by date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  Widget _buildFilterButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingM,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'All Posts',
              isSelected: _selectedFilter == PostFilterType.all,
              onTap: () {
                setState(() {
                  _selectedFilter = PostFilterType.all;
                });
              },
            ),
            const SizedBox(width: DesignTokens.spacingS),
            _buildFilterChip(
              label: 'Admin Posts',
              isSelected: _selectedFilter == PostFilterType.admin,
              onTap: () {
                setState(() {
                  _selectedFilter = PostFilterType.admin;
                });
              },
            ),
            const SizedBox(width: DesignTokens.spacingS),
            _buildFilterChip(
              label: 'Members Posts',
              isSelected: _selectedFilter == PostFilterType.members,
              onTap: () {
                setState(() {
                  _selectedFilter = PostFilterType.members;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingL,
          vertical: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryOrange : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeM,
            fontWeight: isSelected
                ? DesignTokens.fontWeightBold
                : DesignTokens.fontWeightSemiBold,
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _posts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_posts.isEmpty && !_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.post_add_outlined,
                size: 80,
                color: AppColors.grey400,
              ),
              const SizedBox(height: 24),
              Text(
                'No posts found',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: AppColors.grey700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Be the first to post in this category!',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeM,
                  color: AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostComposerScreen(
                        initialCategory:
                            widget.category ?? PostCategory.discussion,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Post'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildFilterButtons(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshPosts,
            child: Builder(
              builder: (context) {
                final filteredPosts = _getFilteredPosts();

                if (filteredPosts.isEmpty && !_isLoading) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.post_add_outlined,
                            size: 80,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No posts found',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeXL,
                              fontWeight: DesignTokens.fontWeightBold,
                              color: AppColors.grey700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _selectedFilter == PostFilterType.all
                                ? 'Be the first to post in this category!'
                                : _selectedFilter == PostFilterType.admin
                                    ? 'No admin posts found in this category'
                                    : 'No member posts found in this category',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeM,
                              color: AppColors.grey500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(DesignTokens.spacingM),
                  itemCount: filteredPosts.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredPosts.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final post = filteredPosts[index];
                    final isAdmin = _userCache[post.authorId]?.isAdmin ??
                        post.isAnnouncement;

                    return RepaintBoundary(
                      child: PostItemWidget(
                        post: post,
                        isAdminPost: isAdmin,
                        onPostUpdated: () {
                          _refreshPosts();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
