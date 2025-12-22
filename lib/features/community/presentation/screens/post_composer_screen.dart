import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../shared/models/post_model.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../auth/providers/auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
      _isAnnouncement = widget.initialCategory == PostCategory.announcement;
    }
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

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
      if (_selectedVideos.length >= 1) {
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
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final isAdmin = user?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isPosting ? null : _handleSubmit,
            child: _isPosting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Selection
              _buildCategorySelection(isAdmin),
              const SizedBox(height: 16),

              // Content Field
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'What\'s on your mind?',
                  hintText: 'Write something...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Media Preview
              if (_selectedImages.isNotEmpty) _buildImagePreview(),
              if (_selectedVideos.isNotEmpty) _buildVideoPreview(),

              // Upload Progress Indicator
              if (_isPosting && _uploadStatus.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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

              const SizedBox(height: 16),

              // Media Selection Buttons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: _pickImages,
                    tooltip: 'Add Photos',
                  ),
                  IconButton(
                    icon: const Icon(Icons.video_library),
                    onPressed: _pickVideo,
                    tooltip: 'Add Video',
                  ),
                  if (_selectedImages.isNotEmpty || _selectedVideos.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _selectedImages = [];
                          _selectedVideos = [];
                        });
                      },
                      tooltip: 'Remove Media',
                    ),
                  // Show limits
                  if (_selectedImages.length >= 3)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Max 3 images (5MB each)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  if (_selectedVideos.length >= 1)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Max 1 video (50MB)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                ],
              ),

              if (isAdmin) ...[
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Mark as Announcement'),
                  value: _isAnnouncement,
                  onChanged: (value) {
                    setState(() {
                      _isAnnouncement = value ?? false;
                      if (_isAnnouncement) {
                        _selectedCategory = PostCategory.announcement;
                      }
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection(bool isAdmin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: PostCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            final isDisabled =
                !isAdmin && category == PostCategory.announcement;

            return FilterChip(
              label: Text(_getCategoryLabel(category)),
              selected: isSelected,
              onSelected: isDisabled
                  ? null
                  : (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                          if (category == PostCategory.announcement) {
                            _isAnnouncement = true;
                          }
                        });
                      }
                    },
            );
          }).toList(),
        ),
      ],
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
