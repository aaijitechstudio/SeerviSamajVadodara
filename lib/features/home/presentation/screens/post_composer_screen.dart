import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/post_provider.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../core/utils/app_utils.dart';

class PostComposerScreen extends ConsumerStatefulWidget {
  const PostComposerScreen({super.key});

  @override
  ConsumerState<PostComposerScreen> createState() => _PostComposerScreenState();
}

class _PostComposerScreenState extends ConsumerState<PostComposerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  PostType _selectedType = PostType.text;
  List<File> _selectedImages = [];
  File? _selectedVideo;
  bool _isAnnouncement = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final postState = ref.watch(postControllerProvider);
              return TextButton(
                onPressed: postState.isLoading ? null : _handleSubmit,
                child: postState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Post',
                        style: TextStyle(color: Colors.white),
                      ),
              );
            },
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
              // Post Type Selection
              _buildPostTypeSelection(),
              const SizedBox(height: 16),

              // Content Field
              _buildContentField(),
              const SizedBox(height: 16),

              // Media Preview
              if (_selectedImages.isNotEmpty || _selectedVideo != null)
                _buildMediaPreview(),

              const SizedBox(height: 16),

              // Media Selection Buttons
              _buildMediaSelectionButtons(),
              const SizedBox(height: 16),

              // Announcement Toggle
              _buildAnnouncementToggle(),
              const SizedBox(height: 24),

              // Error Message
              Consumer(
                builder: (context, ref, child) {
                  final postState = ref.watch(postControllerProvider);
                  if (postState.error != null) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Text(
                        postState.error!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostTypeSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Post Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTypeOption(
                      PostType.text, Icons.text_fields, 'Text'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeOption(PostType.image, Icons.image, 'Image'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      _buildTypeOption(PostType.video, Icons.videocam, 'Video'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(PostType type, IconData icon, String label) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          if (type != PostType.image) _selectedImages.clear();
          if (type != PostType.video) _selectedVideo = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          controller: _contentController,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'What\'s on your mind?',
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter some content';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Media Preview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedImages.isNotEmpty) ...[
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImages[index],
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            if (_selectedVideo != null) ...[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.videocam,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Video Selected',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedVideo = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSelectionButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Media',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (_selectedType == PostType.image) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Add Photos'),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (_selectedType == PostType.video) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickVideo,
                      icon: const Icon(Icons.videocam),
                      label: const Text('Add Video'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.campaign, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Make this an announcement',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Announcements are highlighted and shown to all members',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isAnnouncement,
              onChanged: (value) {
                setState(() {
                  _isAnnouncement = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      setState(() {
        _selectedImages = images.map((image) => File(image.path)).toList();
      });
    } catch (e) {
      if (!mounted) return;
      AppUtils.showErrorSnackBar(context, 'Failed to pick images: $e');
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedVideo = File(video.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppUtils.showErrorSnackBar(context, 'Failed to pick video: $e');
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final postController = ref.read(postControllerProvider.notifier);

    // Convert images to URLs (this would typically upload to Firebase Storage)
    List<String>? imageUrls;
    if (_selectedImages.isNotEmpty) {
      // In a real app, you would upload images to Firebase Storage here
      imageUrls = _selectedImages.map((image) => image.path).toList();
    }

    // Convert video to URL (this would typically upload to Firebase Storage)
    String? videoUrl;
    if (_selectedVideo != null) {
      // In a real app, you would upload video to Firebase Storage here
      videoUrl = _selectedVideo!.path;
    }

    final success = await postController.createPost(
      content: _contentController.text.trim(),
      type: _selectedType,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
      isAnnouncement: _isAnnouncement,
    );

    if (success) {
      if (!mounted) return;
      Navigator.of(context).pop();
      if (!mounted) return;
      AppUtils.showSuccessSnackBar(context, 'Post created successfully!');
    }
  }
}
