import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../home/data/repositories/post_repository.dart';
import '../screens/post_composer_screen.dart';
import 'post_item_widget.dart';

class PostListWidget extends ConsumerStatefulWidget {
  final PostCategory category;

  const PostListWidget({
    super.key,
    required this.category,
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
      final result = await postRepository.getPostsByCategory(
        widget.category,
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
      final result = await postRepository.getPostsByCategory(
        widget.category,
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
    });
    await _loadPosts();
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
                color: DesignTokens.grey400,
              ),
              const SizedBox(height: 24),
              Text(
                'No posts found',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.grey700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Be the first to post in this category!',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeM,
                  color: DesignTokens.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostComposerScreen(
                        initialCategory: widget.category,
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

    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        itemCount: _posts.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return PostItemWidget(
            post: _posts[index],
            onPostUpdated: () {
              _refreshPosts();
            },
          );
        },
      ),
    );
  }
}
