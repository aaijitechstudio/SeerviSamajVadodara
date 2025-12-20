import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/widgets/page_transitions.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/models/vadodara_news_model.dart';
import '../../data/vadodara_news_service.dart';
import 'enewspapers_screen.dart';
import 'webview_screen.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<VadodaraNews> _vadodaraNews = [];
  List<VadodaraNews> _businessNews = [];
  List<VadodaraNews> _rajasthanNews = [];
  bool _isLoadingNews = false;
  bool _isLoadingBusinessNews = false;
  bool _isLoadingRajasthanNews = false;
  bool _isLoadingMoreNews = false;
  bool _isLoadingMoreBusinessNews = false;
  bool _isLoadingMoreRajasthanNews = false;
  String? _newsError;
  String? _businessNewsError;
  String? _rajasthanNewsError;
  String? _vadodaraNextPage;
  String? _businessNextPage;
  String? _rajasthanNextPage;
  bool _hasMoreVadodaraNews = true;
  bool _hasMoreBusinessNews = true;
  bool _hasMoreRajasthanNews = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    // Only load news when tab is actually viewed - lazy loading
    _tabController.addListener(_onTabChanged);
    // Load initial tab data
    _loadInitialData();
  }

  @override
  void didUpdateWidget(NewsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recreate TabController if length changed (for hot reload)
    if (_tabController.length != 4) {
      _tabController.removeListener(_onTabChanged);
      _tabController.dispose();
      _tabController = TabController(
          length: 4,
          vsync: this,
          initialIndex: _tabController.index.clamp(0, 3));
      _tabController.addListener(_onTabChanged);
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _loadInitialData();
    }
  }

  void _loadInitialData() {
    // Only load data for the currently visible tab to avoid background work
    final currentIndex = _tabController.index;
    if (currentIndex == 1 && _vadodaraNews.isEmpty && !_isLoadingNews) {
      _loadVadodaraNews();
    } else if (currentIndex == 2 &&
        _rajasthanNews.isEmpty &&
        !_isLoadingRajasthanNews) {
      _loadRajasthanNews();
    } else if (currentIndex == 3 &&
        _businessNews.isEmpty &&
        !_isLoadingBusinessNews) {
      _loadBusinessNews();
    }
  }

  void _navigateToENewspapers(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ENewspapersScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadVadodaraNews({bool loadMore = false}) async {
    if (!mounted) return;
    if (loadMore && (!_hasMoreVadodaraNews || _isLoadingMoreNews)) return;

    setState(() {
      if (loadMore) {
        _isLoadingMoreNews = true;
      } else {
        _isLoadingNews = true;
        _newsError = null;
        _vadodaraNews = [];
        _vadodaraNextPage = null;
        _hasMoreVadodaraNews = true;
      }
    });

    try {
      final response = await VadodaraNewsService.fetchVadodaraNews(
        nextPage: loadMore ? _vadodaraNextPage : null,
      );
      if (!mounted) return;

      setState(() {
        if (loadMore) {
          _vadodaraNews.addAll(response.news);
          _isLoadingMoreNews = false;
        } else {
          _vadodaraNews = response.news;
          _isLoadingNews = false;
        }
        _vadodaraNextPage = response.nextPage;
        _hasMoreVadodaraNews = response.nextPage != null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        if (loadMore) {
          _isLoadingMoreNews = false;
        } else {
          _newsError = e.toString();
          _isLoadingNews = false;
        }
      });
    }
  }

  Future<void> _loadRajasthanNews({bool loadMore = false}) async {
    if (!mounted) return;
    if (loadMore && (!_hasMoreRajasthanNews || _isLoadingMoreRajasthanNews))
      return;

    setState(() {
      if (loadMore) {
        _isLoadingMoreRajasthanNews = true;
      } else {
        _isLoadingRajasthanNews = true;
        _rajasthanNewsError = null;
        _rajasthanNews = [];
        _rajasthanNextPage = null;
        _hasMoreRajasthanNews = true;
      }
    });

    try {
      final response = await VadodaraNewsService.fetchRajasthanNews(
        nextPage: loadMore ? _rajasthanNextPage : null,
      );
      if (!mounted) return;

      setState(() {
        if (loadMore) {
          _rajasthanNews.addAll(response.news);
          _isLoadingMoreRajasthanNews = false;
        } else {
          _rajasthanNews = response.news;
          _isLoadingRajasthanNews = false;
        }
        _rajasthanNextPage = response.nextPage;
        _hasMoreRajasthanNews = response.nextPage != null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        if (loadMore) {
          _isLoadingMoreRajasthanNews = false;
        } else {
          _rajasthanNewsError = e.toString();
          _isLoadingRajasthanNews = false;
        }
      });
    }
  }

  Future<void> _loadBusinessNews({bool loadMore = false}) async {
    if (!mounted) return;
    if (loadMore && (!_hasMoreBusinessNews || _isLoadingMoreBusinessNews))
      return;

    setState(() {
      if (loadMore) {
        _isLoadingMoreBusinessNews = true;
      } else {
        _isLoadingBusinessNews = true;
        _businessNewsError = null;
        _businessNews = [];
        _businessNextPage = null;
        _hasMoreBusinessNews = true;
      }
    });

    try {
      final response = await VadodaraNewsService.fetchBusinessNews(
        nextPage: loadMore ? _businessNextPage : null,
      );
      if (!mounted) return;

      setState(() {
        if (loadMore) {
          _businessNews.addAll(response.news);
          _isLoadingMoreBusinessNews = false;
        } else {
          _businessNews = response.news;
          _isLoadingBusinessNews = false;
        }
        _businessNextPage = response.nextPage;
        _hasMoreBusinessNews = response.nextPage != null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        if (loadMore) {
          _isLoadingMoreBusinessNews = false;
        } else {
          _businessNewsError = e.toString();
          _isLoadingBusinessNews = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Safety check: Ensure TabController has correct length (for hot reload)
    if (_tabController.length != 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _tabController.removeListener(_onTabChanged);
          _tabController.dispose();
          _tabController =
              TabController(length: 4, vsync: this, initialIndex: 0);
          _tabController.addListener(_onTabChanged);
          setState(() {});
        }
      });
    }

    return Scaffold(
      backgroundColor: DesignTokens.backgroundWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.newsAnnouncements),
        centerTitle: true,
        backgroundColor: DesignTokens.backgroundWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.newspaper),
            tooltip: l10n.eNewspapers,
            onPressed: () => _navigateToENewspapers(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: DesignTokens.primaryOrange,
          unselectedLabelColor: DesignTokens.textSecondary,
          indicatorColor: DesignTokens.primaryOrange,
          tabs: [
            Tab(text: l10n.social),
            Tab(text: l10n.gujaratNews),
            Tab(text: l10n.rajasthanNews),
            Tab(text: l10n.businessNews),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _buildSocialSamajNews(l10n),
          _buildVadodaraNews(l10n),
          _buildRajasthanNews(l10n),
          _buildBusinessNews(l10n),
        ],
      ),
    );
  }

  // Social News Tab (Temporarily Disabled)
  Widget _buildSocialSamajNews(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pause_circle_outline,
              size: 80,
              color: DesignTokens.primaryOrange.withValues(alpha: 0.6),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              l10n.socialNewsPaused,
              style: const TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              l10n.socialNewsPausedDescription,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeM,
                color: DesignTokens.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Vadodara News Tab
  Widget _buildVadodaraNews(AppLocalizations l10n) {
    if (_isLoadingNews) {
      return FullScreenLoader(message: l10n.loading);
    }

    if (_newsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: DesignTokens.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              _newsError!.contains('API key')
                  ? l10n.apiKeyNotSet
                  : l10n.failedToLoadNews,
              textAlign: TextAlign.center,
              style: TextStyle(color: DesignTokens.errorColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadVadodaraNews,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
            ),
          ],
        ),
      );
    }

    if (_vadodaraNews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noNewsAvailable,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _loadVadodaraNews(loadMore: false),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadVadodaraNews(loadMore: false),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            final metrics = scrollInfo.metrics;
            if (!_isLoadingMoreNews &&
                _hasMoreVadodaraNews &&
                metrics.pixels >= metrics.maxScrollExtent - 200) {
              _loadVadodaraNews(loadMore: true);
            }
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          itemCount: _vadodaraNews.length + (_hasMoreVadodaraNews ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _vadodaraNews.length) {
              return const Padding(
                padding: EdgeInsets.all(DesignTokens.spacingM),
                child: Center(child: InlineLoader()),
              );
            }
            return _buildVadodaraNewsCard(context, _vadodaraNews[index], l10n);
          },
        ),
      ),
    );
  }

  // Rajasthan News Tab
  Widget _buildRajasthanNews(AppLocalizations l10n) {
    if (_isLoadingRajasthanNews) {
      return FullScreenLoader(message: l10n.loading);
    }

    if (_rajasthanNewsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: DesignTokens.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              _rajasthanNewsError!.contains('API key')
                  ? l10n.apiKeyNotSet
                  : l10n.failedToLoadNews,
              textAlign: TextAlign.center,
              style: TextStyle(color: DesignTokens.errorColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadRajasthanNews,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
            ),
          ],
        ),
      );
    }

    if (_rajasthanNews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noNewsAvailable,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _loadRajasthanNews(loadMore: false),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadRajasthanNews(loadMore: false),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            final metrics = scrollInfo.metrics;
            if (!_isLoadingMoreRajasthanNews &&
                _hasMoreRajasthanNews &&
                metrics.pixels >= metrics.maxScrollExtent - 200) {
              _loadRajasthanNews(loadMore: true);
            }
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          itemCount: _rajasthanNews.length + (_hasMoreRajasthanNews ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _rajasthanNews.length) {
              return const Padding(
                padding: EdgeInsets.all(DesignTokens.spacingM),
                child: Center(child: InlineLoader()),
              );
            }
            return _buildVadodaraNewsCard(context, _rajasthanNews[index], l10n);
          },
        ),
      ),
    );
  }

  // Business News Tab
  Widget _buildBusinessNews(AppLocalizations l10n) {
    if (_isLoadingBusinessNews) {
      return FullScreenLoader(message: l10n.loading);
    }

    if (_businessNewsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: DesignTokens.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              _businessNewsError!.contains('API key')
                  ? l10n.apiKeyNotSet
                  : l10n.failedToLoadNews,
              textAlign: TextAlign.center,
              style: TextStyle(color: DesignTokens.errorColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadBusinessNews,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
            ),
          ],
        ),
      );
    }

    if (_businessNews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_center_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noNewsAvailable,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _loadBusinessNews(loadMore: false),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadBusinessNews(loadMore: false),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            final metrics = scrollInfo.metrics;
            if (!_isLoadingMoreBusinessNews &&
                _hasMoreBusinessNews &&
                metrics.pixels >= metrics.maxScrollExtent - 200) {
              _loadBusinessNews(loadMore: true);
            }
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          itemCount: _businessNews.length + (_hasMoreBusinessNews ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _businessNews.length) {
              return const Padding(
                padding: EdgeInsets.all(DesignTokens.spacingM),
                child: Center(child: InlineLoader()),
              );
            }
            return _buildVadodaraNewsCard(context, _businessNews[index], l10n);
          },
        ),
      ),
    );
  }

  Widget _buildVadodaraNewsCard(
    BuildContext context,
    VadodaraNews news,
    AppLocalizations l10n,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingM),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: InkWell(
        onTap: news.link != null
            ? () {
                Navigator.of(context).push(
                  PageTransitions.fadeSlideRoute(
                    WebViewScreen(
                      url: news.link!,
                      title: news.title,
                    ),
                  ),
                );
              }
            : null,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(DesignTokens.radiusM),
                ),
                child: Image.network(
                  news.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: DesignTokens.fontSizeXL,
                      fontWeight: DesignTokens.fontWeightBold,
                    ),
                  ),
                  if (news.description.isNotEmpty) ...[
                    const SizedBox(height: DesignTokens.spacingS),
                    Text(
                      news.description,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeM,
                        color: DesignTokens.textPrimary,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: DesignTokens.spacingM),
                  Row(
                    children: [
                      if (news.source != null) ...[
                        Icon(
                          Icons.article,
                          size: 16,
                          color: DesignTokens.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            news.source!,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeS,
                              color: DesignTokens.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingM),
                      ],
                      if (news.pubDate != null) ...[
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: DesignTokens.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${l10n.publishedOn}: ${dateFormat.format(news.pubDate!)}',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeS,
                              color: DesignTokens.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (news.link != null) ...[
                    const SizedBox(height: DesignTokens.spacingS),
                    Text(
                      l10n.readMore,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeS,
                        color: DesignTokens.primaryOrange,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
