import 'package:flutter/material.dart';
// (removed unused foundation import)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../shared/models/post_model.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../home/providers/post_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/widgets/responsive_page.dart';

class PostComposerScreen extends ConsumerStatefulWidget {
  final PostCategory? initialCategory;

  const PostComposerScreen({
    super.key,
    this.initialCategory,
  });

  @override
  ConsumerState<PostComposerScreen> createState() => _PostComposerScreenState();
}

class _PostComposerScreenState extends ConsumerState<PostComposerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  PostCategory _selectedCategory = PostCategory.discussion;
  List<File> _selectedImages = [];
  List<File> _selectedVideos = [];
  bool _isAnnouncement = false;
  bool _isPosting = false;
  String _uploadStatus = '';
  double _uploadProgress = 0.0;
  String? _selectedMusic;
  String? _selectedPeople;
  String? _selectedLocation;
  String? _selectedFeeling;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
      _isAnnouncement = widget.initialCategory == PostCategory.announcement;
    }
    _contentController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  String _getCategoryLabel(PostCategory category) {
    switch (category) {
      case PostCategory.announcement:
        return '📢 Announcements';
      case PostCategory.discussion:
        return '💬 Discussion';
      case PostCategory.events:
        return '🎉 Events';
      case PostCategory.gallery:
        return '📸 Gallery';
    }
  }

  bool get _canPost {
    final hasText = _contentController.text.trim().isNotEmpty;
    final hasMedia = _selectedImages.isNotEmpty || _selectedVideos.isNotEmpty;
    return (hasText || hasMedia) && !_isPosting;
  }

  Future<void> _handleSubmit() async {
    final hasText = _contentController.text.trim().isNotEmpty;
    final hasMedia = _selectedImages.isNotEmpty || _selectedVideos.isNotEmpty;
    if (!hasText && !hasMedia) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Write something or add media to post.')),
        );
      }
      return;
    }

    final authState = ref.read(authControllerProvider);
    final user = authState.user;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to post')),
        );
      }
      return;
    }

    if (_isPosting) return;

    setState(() {
      _isPosting = true;
    });

    try {
      // Upload images if any (with error handling and progress)
      // Limit to 3 images
      List<String>? imageUrls;
      if (_selectedImages.isNotEmpty) {
        // Ensure max 3 images
        final imagesToUpload = _selectedImages.take(3).toList();
        try {
          setState(() {
            _uploadStatus = 'Uploading images...';
            _uploadProgress = 0.0;
          });
          imageUrls = await _uploadImages(imagesToUpload);
          setState(() {
            _uploadStatus = 'Images uploaded successfully';
            _uploadProgress = 1.0;
          });
        } catch (e) {
          setState(() {
            _uploadStatus = '';
            _uploadProgress = 0.0;
          });
          if (mounted) {
            String errorMsg = e.toString();
            if (errorMsg.contains('PERMISSION_DENIED') ||
                errorMsg.contains('permission')) {
              errorMsg =
                  'Storage permission denied. Please deploy storage rules.';
            } else if (errorMsg.contains('object-not-found')) {
              errorMsg =
                  'Storage bucket not configured. Please deploy storage rules.';
            }

            final shouldContinue = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Image Upload Failed'),
                content: Text(
                  '$errorMsg\n\nWould you like to create the post without images?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Continue Without Images'),
                  ),
                ],
              ),
            );
            if (shouldContinue != true) {
              setState(() {
                _isPosting = false;
              });
              return;
            }
          }
        }
      }

      // Upload videos if any (with error handling and progress)
      // Limit to 1 video
      List<String>? videoUrls;
      if (_selectedVideos.isNotEmpty) {
        // Ensure max 1 video
        final videosToUpload = _selectedVideos.take(1).toList();
        try {
          setState(() {
            _uploadStatus = 'Uploading videos...';
            _uploadProgress = 0.0;
          });
          videoUrls = await _uploadVideos(videosToUpload);
          setState(() {
            _uploadStatus = 'Videos uploaded successfully';
            _uploadProgress = 1.0;
          });
        } catch (e) {
          setState(() {
            _uploadStatus = '';
            _uploadProgress = 0.0;
          });
          if (mounted) {
            String errorMsg = e.toString();
            if (errorMsg.contains('PERMISSION_DENIED') ||
                errorMsg.contains('permission')) {
              errorMsg =
                  'Storage permission denied. Please deploy storage rules.';
            } else if (errorMsg.contains('object-not-found')) {
              errorMsg =
                  'Storage bucket not configured. Please deploy storage rules.';
            }

            final shouldContinue = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Video Upload Failed'),
                content: Text(
                  '$errorMsg\n\nWould you like to create the post without videos?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Continue Without Videos'),
                  ),
                ],
              ),
            );
            if (shouldContinue != true) {
              setState(() {
                _isPosting = false;
              });
              return;
            }
          }
        }
      }

      // Reset upload status before creating post
      setState(() {
        _uploadStatus = 'Creating post...';
        _uploadProgress = 0.0;
      });

      // Determine post type
      PostType postType = PostType.text;
      if (imageUrls != null && imageUrls.isNotEmpty) {
        postType = PostType.image;
      } else if (videoUrls != null && videoUrls.isNotEmpty) {
        postType = PostType.video;
      }

      // Create post
      final post = PostModel(
        id: '',
        authorId: user.id,
        authorName: user.name,
        authorProfileImage: user.profileImageUrl,
        content: _contentController.text.trim(),
        type: postType,
        imageUrls: imageUrls,
        videoUrls: videoUrls,
        createdAt: DateTime.now(),
        isAnnouncement:
            _isAnnouncement || _selectedCategory == PostCategory.announcement,
        category: _selectedCategory,
        metadata: {
          if (_selectedMusic != null) 'music': _selectedMusic,
          if (_selectedPeople != null) 'people': _selectedPeople,
          if (_selectedLocation != null) 'location': _selectedLocation,
          if (_selectedFeeling != null) 'feeling': _selectedFeeling,
        },
      );

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
        return;
      }

      // Debug: Print post data before creating
      debugPrint('Creating post with data: ${post.toMap()}');
      debugPrint('User ID: ${user.id}');
      debugPrint('Author ID in post: ${post.authorId}');

      final result = await postRepository.createPost(post);

      if (result.failure != null) {
        if (mounted) {
          final errorMessage = result.failure!.message;
          debugPrint('Post creation failed: $errorMessage');

          // Show detailed error message
          String userFriendlyMessage = errorMessage;
          if (errorMessage.contains('PERMISSION_DENIED') ||
              errorMessage.contains('permission')) {
            userFriendlyMessage = 'Permission denied. Please make sure:\n'
                '1. You are logged in\n'
                '2. Firestore rules are deployed\n'
                '3. Try again after a few seconds';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create post: $userFriendlyMessage'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
      } else {
        setState(() {
          _uploadStatus = '';
          _uploadProgress = 0.0;
        });
        if (mounted) {
          // Trigger post list refresh by incrementing the refresh trigger
          ref.read(postRefreshTriggerProvider.notifier).state++;
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating post: ${e.toString()}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    final List<String> urls = [];
    final storage = FirebaseStorage.instance;
    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.id ?? 'unknown';
    final totalImages = images.length;

    for (int i = 0; i < images.length; i++) {
      final imageFile = images[i];
      try {
        // Update progress
        if (mounted) {
          setState(() {
            _uploadProgress = i / totalImages;
            _uploadStatus = 'Uploading image ${i + 1} of $totalImages...';
          });
        }

        // Generate unique filename
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final random = (timestamp % 100000).toString();
        final extension = imageFile.path.split('.').last.toLowerCase();
        final fileName =
            'posts/images/${userId}_${timestamp}_$random.$extension';

        final storageRef = storage.ref().child(fileName);

        // Determine content type
        String contentType = 'image/jpeg';
        if (extension == 'png') {
          contentType = 'image/png';
        } else if (extension == 'gif') {
          contentType = 'image/gif';
        } else if (extension == 'webp') {
          contentType = 'image/webp';
        }

        // Upload with metadata and progress tracking
        final uploadTask = storageRef.putFile(
          imageFile,
          SettableMetadata(
            contentType: contentType,
            customMetadata: {
              'uploadedBy': userId,
              'uploadedAt': DateTime.now().toIso8601String(),
            },
          ),
        );

        // Track upload progress
        uploadTask.snapshotEvents.listen((snapshot) {
          if (mounted) {
            final progress =
                (i + snapshot.bytesTransferred / snapshot.totalBytes) /
                    totalImages;
            setState(() {
              _uploadProgress = progress.clamp(0.0, 1.0);
            });
          }
        });

        await uploadTask;

        final url = await storageRef.getDownloadURL();
        urls.add(url);
      } catch (e) {
        debugPrint('Failed to upload image ${i + 1}: $e');
        rethrow; // Re-throw to show error dialog
      }
    }

    return urls;
  }

  Future<List<String>> _uploadVideos(List<File> videos) async {
    final List<String> urls = [];
    final storage = FirebaseStorage.instance;
    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.id ?? 'unknown';
    final totalVideos = videos.length;

    for (int i = 0; i < videos.length; i++) {
      final videoFile = videos[i];
      try {
        // Update progress
        if (mounted) {
          setState(() {
            _uploadProgress = i / totalVideos;
            _uploadStatus = 'Uploading video ${i + 1} of $totalVideos...';
          });
        }

        // Generate unique filename
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final random = (timestamp % 100000).toString();
        final extension = videoFile.path.split('.').last.toLowerCase();
        final fileName =
            'posts/videos/${userId}_${timestamp}_${i}_$random.$extension';

        final storageRef = storage.ref().child(fileName);

        // Determine content type
        String contentType = 'video/mp4';
        if (extension == 'mov') {
          contentType = 'video/quicktime';
        } else if (extension == 'avi') {
          contentType = 'video/x-msvideo';
        } else if (extension == 'mkv') {
          contentType = 'video/x-matroska';
        }

        // Upload with metadata and progress tracking
        final uploadTask = storageRef.putFile(
          videoFile,
          SettableMetadata(
            contentType: contentType,
            customMetadata: {
              'uploadedBy': userId,
              'uploadedAt': DateTime.now().toIso8601String(),
            },
          ),
        );

        // Track upload progress
        uploadTask.snapshotEvents.listen((snapshot) {
          if (mounted) {
            final progress =
                (i + snapshot.bytesTransferred / snapshot.totalBytes) /
                    totalVideos;
            setState(() {
              _uploadProgress = progress.clamp(0.0, 1.0);
              _uploadStatus =
                  'Uploading video ${i + 1}: ${((snapshot.bytesTransferred / snapshot.totalBytes) * 100).toStringAsFixed(0)}%';
            });
          }
        });

        await uploadTask;

        final url = await storageRef.getDownloadURL();
        urls.add(url);
      } catch (e) {
        debugPrint('Failed to upload video ${i + 1}: $e');
        rethrow;
      }
    }

    return urls;
  }

  Future<void> _pickImages() async {
    try {
      // Check if already have 3 images
      if (_selectedImages.length >= 3) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum 3 images allowed per post.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        // Limit to 3 images total
        final remainingSlots = 3 - _selectedImages.length;
        final newImages = images
            .take(remainingSlots)
            .map((image) => File(image.path))
            .toList();
        setState(() {
          _selectedImages.addAll(newImages);
          _selectedVideos = []; // Clear videos when selecting images
        });
        if (images.length > remainingSlots && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Maximum 3 images allowed. Only $remainingSlots more image(s) added.'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking images: $e')),
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      // Check if already have 1 video
      if (_selectedVideos.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum 1 video allowed per post.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedVideos.add(File(video.path));
          _selectedImages = []; // Clear images when selecting videos
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking video: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final keyboardOpen = mq.viewInsets.bottom > 0;
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final isAdmin = user?.isAdmin ?? false;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('New post'),
          centerTitle: true,
        ),
        body: const Center(child: Text('Please login to create a post')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('New post'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            tooltip: 'More',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isAdmin)
                            SwitchListTile(
                              title: const Text('Mark as Announcement'),
                              value: _isAnnouncement,
                              onChanged: (value) {
                                setState(() {
                                  _isAnnouncement = value;
                                  if (_isAnnouncement) {
                                    _selectedCategory =
                                        PostCategory.announcement;
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ListTile(
                            leading: const Icon(Icons.category_outlined),
                            title: const Text('Category'),
                            subtitle:
                                Text(_getCategoryLabel(_selectedCategory)),
                            onTap: () {
                              Navigator.of(context).pop();
                              _showCategoryPicker(context, isAdmin);
                            },
                          ),
                          if (_selectedImages.isNotEmpty ||
                              _selectedVideos.isNotEmpty)
                            ListTile(
                              leading: const Icon(Icons.delete_outline),
                              title: const Text('Remove media'),
                              onTap: () {
                                setState(() {
                                  _selectedImages = [];
                                  _selectedVideos = [];
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      // We'll manage keyboard layout manually to avoid any overflows.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main content (kept scrollable). We add bottom padding to avoid being hidden by the composer bar.
            Padding(
              padding: const EdgeInsets.only(bottom: 170),
              child: Column(
                children: [
                  // Header row: avatar + name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: (user.profileImageUrl != null &&
                                  (user.profileImageUrl as String).isNotEmpty)
                              ? NetworkImage(user.profileImageUrl as String)
                              : null,
                          child: (user.profileImageUrl == null ||
                                  (user.profileImageUrl as String).isEmpty)
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _Pill(
                                    icon: Icons.public,
                                    label: 'Friends',
                                    onTap: () {
                                      // Placeholder – can add privacy selection later.
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  _Pill(
                                    icon: Icons.category_outlined,
                                    label: _selectedCategory
                                        .toString()
                                        .split('.')
                                        .last,
                                    onTap: () =>
                                        _showCategoryPicker(context, isAdmin),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quick actions row (simple and tappable)
                  SizedBox(
                    height: 44,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _QuickChip(
                          icon: Icons.music_note,
                          label: _selectedMusic == null ? 'Music' : 'Music ✓',
                          onTap: () => _pickMusic(context),
                        ),
                        _QuickChip(
                          icon: Icons.person_add_alt_1,
                          label:
                              _selectedPeople == null ? 'People' : 'People ✓',
                          onTap: () => _pickPeople(context),
                        ),
                        _QuickChip(
                          icon: Icons.location_on_outlined,
                          label: _selectedLocation == null
                              ? 'Location'
                              : 'Location ✓',
                          onTap: () => _pickLocation(context),
                        ),
                        _QuickChip(
                          icon: Icons.emoji_emotions_outlined,
                          label: _selectedFeeling == null
                              ? 'Feeling'
                              : 'Feeling ✓',
                          onTap: () => _pickFeeling(context),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Main editor (scrolls when keyboard shows)
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: ResponsivePage(
                          useSafeArea: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_selectedMusic != null ||
                                  _selectedPeople != null ||
                                  _selectedLocation != null ||
                                  _selectedFeeling != null) ...[
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    if (_selectedMusic != null)
                                      Chip(
                                        label: Text('🎵 ${_selectedMusic!}'),
                                        onDeleted: () => setState(
                                            () => _selectedMusic = null),
                                      ),
                                    if (_selectedPeople != null)
                                      Chip(
                                        label: Text('👥 ${_selectedPeople!}'),
                                        onDeleted: () => setState(
                                            () => _selectedPeople = null),
                                      ),
                                    if (_selectedLocation != null)
                                      Chip(
                                        label: Text('📍 ${_selectedLocation!}'),
                                        onDeleted: () => setState(
                                            () => _selectedLocation = null),
                                      ),
                                    if (_selectedFeeling != null)
                                      Chip(
                                        label: Text('😊 ${_selectedFeeling!}'),
                                        onDeleted: () => setState(
                                            () => _selectedFeeling = null),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                              TextField(
                                controller: _contentController,
                                maxLines: null,
                                minLines: 6,
                                decoration: const InputDecoration(
                                  hintText: "What's on your mind?",
                                  border: InputBorder.none,
                                ),
                                style:
                                    const TextStyle(fontSize: 20, height: 1.3),
                              ),
                              if (_selectedImages.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _buildImagePreview(),
                              ],
                              if (_selectedVideos.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _buildVideoPreview(),
                              ],
                              if (_isPosting && _uploadStatus.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _uploadStatus,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: _uploadProgress,
                                        backgroundColor: Colors.blue.shade100,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom composer bar (overlay; moves above keyboard without affecting layout)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
                child: _ComposerBar(
                  keyboardOpen: keyboardOpen,
                  hasMedia:
                      _selectedImages.isNotEmpty || _selectedVideos.isNotEmpty,
                  onPickImages: _pickImages,
                  onPickVideo: _pickVideo,
                  onClearMedia: () {
                    setState(() {
                      _selectedImages = [];
                      _selectedVideos = [];
                    });
                  },
                  canPost: _canPost,
                  isPosting: _isPosting,
                  onPost: _handleSubmit,
                  bottomInset: mq.padding.bottom,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickMusic(BuildContext context) async {
    final controller = TextEditingController(text: _selectedMusic ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add music'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Song name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    final value = result?.trim();
    if (!mounted) return;
    setState(() {
      _selectedMusic = (value == null || value.isEmpty) ? null : value;
    });
  }

  Future<void> _pickPeople(BuildContext context) async {
    final controller = TextEditingController(text: _selectedPeople ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tag people'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Names (e.g., Ram, Shyam)',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    final value = result?.trim();
    if (!mounted) return;
    setState(() {
      _selectedPeople = (value == null || value.isEmpty) ? null : value;
    });
  }

  Future<void> _pickLocation(BuildContext context) async {
    final controller = TextEditingController(text: _selectedLocation ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'City / Place (e.g., Vadodara)',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    final value = result?.trim();
    if (!mounted) return;
    setState(() {
      _selectedLocation = (value == null || value.isEmpty) ? null : value;
    });
  }

  Future<void> _pickFeeling(BuildContext context) async {
    const feelings = [
      'Happy',
      'Blessed',
      'Excited',
      'Grateful',
      'Proud',
      'Sad',
    ];
    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final f in feelings)
              ListTile(
                title: Text(f),
                onTap: () => Navigator.of(context).pop(f),
              ),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Remove feeling'),
              onTap: () => Navigator.of(context).pop(''),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      _selectedFeeling = (result == null || result.isEmpty) ? null : result;
    });
  }

  void _showCategoryPicker(BuildContext context, bool isAdmin) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: PostCategory.values.map((category) {
              final isDisabled =
                  !isAdmin && category == PostCategory.announcement;
              final isSelected = _selectedCategory == category;
              return ListTile(
                enabled: !isDisabled,
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                title: Text(_getCategoryLabel(category)),
                onTap: isDisabled
                    ? null
                    : () {
                        setState(() {
                          _selectedCategory = category;
                          if (category == PostCategory.announcement) {
                            _isAnnouncement = true;
                          }
                        });
                        Navigator.of(context).pop();
                      },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                Image.file(
                  _selectedImages[index],
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _selectedImages.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (_selectedVideos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(_selectedVideos.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.black,
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _selectedVideos.removeAt(index);
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Video (Max 50MB)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _Pill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isEnabled;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final fg = isEnabled
        ? Theme.of(context).iconTheme.color
        : Theme.of(context).disabledColor;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 92,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 18),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.0,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  final bool keyboardOpen;
  final bool hasMedia;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;
  final VoidCallback onClearMedia;
  final bool canPost;
  final bool isPosting;
  final VoidCallback onPost;
  final double bottomInset;

  const _ComposerBar({
    required this.keyboardOpen,
    required this.hasMedia,
    required this.onPickImages,
    required this.onPickVideo,
    required this.onClearMedia,
    required this.canPost,
    required this.isPosting,
    required this.onPost,
    required this.bottomInset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: 10 + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!keyboardOpen) ...[
            SizedBox(
              height: 64,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _BottomAction(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: onPickImages,
                  ),
                  _BottomAction(
                    icon: Icons.video_library_outlined,
                    label: 'Video',
                    onTap: onPickVideo,
                  ),
                  _BottomAction(
                    icon: Icons.gif_box_outlined,
                    label: 'GIF',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      );
                    },
                  ),
                  _BottomAction(
                    icon: Icons.clear,
                    label: 'Clear',
                    onTap: onClearMedia,
                    isEnabled: hasMedia,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              if (keyboardOpen) ...[
                IconButton(
                  icon: const Icon(Icons.photo_library_outlined),
                  tooltip: 'Gallery',
                  onPressed: onPickImages,
                ),
                IconButton(
                  icon: const Icon(Icons.video_library_outlined),
                  tooltip: 'Video',
                  onPressed: onPickVideo,
                ),
                if (hasMedia)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear',
                    onPressed: onClearMedia,
                  ),
              ] else ...[
                _Pill(icon: Icons.group, label: 'Friends', onTap: () {}),
                const SizedBox(width: 8),
                _Pill(icon: Icons.lock_open, label: 'On', onTap: () {}),
                const SizedBox(width: 8),
                _Pill(
                    icon: Icons.camera_alt_outlined, label: 'On', onTap: () {}),
              ],
              const Spacer(),
              FilledButton(
                onPressed: canPost ? onPost : null,
                child: isPosting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
