import 'package:flutter/material.dart';
import '../../domain/models/career_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/screens/web_view_screen.dart';
import '../../../../core/screens/video_player_screen.dart';

class CareerDetailScreen extends StatelessWidget {
  final String category;
  final List<CareerModel> careers;

  const CareerDetailScreen({
    super.key,
    required this.category,
    required this.careers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(_getCategoryTitle(category)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: careers.length,
        itemBuilder: (context, index) {
          return _buildCareerDetailCard(context, careers[index]);
        },
      ),
    );
  }

  String _getCategoryTitle(String category) {
    switch (category) {
      case 'after10':
        return 'After 10th';
      case 'after12':
        return 'After 12th';
      case 'college':
        return 'College';
      case 'working':
        return 'Working Youth';
      default:
        return 'Career Guidance';
    }
  }

  Widget _buildCareerDetailCard(BuildContext context, CareerModel career) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              career.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              career.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            if (career.requiredSubjects.isNotEmpty) ...[
              _buildSectionTitle('Required Subjects'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: career.requiredSubjects
                    .map((subject) => Chip(
                          label: Text(subject),
                          backgroundColor:
                              AppColors.primaryOrange.withValues(alpha: 0.1),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (career.careerOptions.isNotEmpty) ...[
              _buildSectionTitle('Career Options'),
              const SizedBox(height: 8),
              ...career.careerOptions.map((option) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 20,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            if (career.freeResources.isNotEmpty) ...[
              _buildSectionTitle('Free Resources'),
              const SizedBox(height: 8),
              ...career.freeResources.map((resource) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _isValidUrl(resource)
                        ? InkWell(
                            onTap: () => _openResource(context, resource),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  _isDirectVideoUrl(resource)
                                      ? Icons.play_circle_outline
                                      : _isVideoPlatformUrl(resource)
                                          ? Icons.video_library
                                          : Icons.link,
                                  size: 20,
                                  color: AppColors.primaryOrange,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                              child: Text(
                                resource,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryOrange,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Icon(
                              _isDirectVideoUrl(resource)
                                  ? Icons.play_circle_outline
                                  : _isVideoPlatformUrl(resource)
                                      ? Icons.video_library
                                      : Icons.link,
                              size: 16,
                              color: AppColors.primaryOrange,
                            ),
                          ],
                        ),
                      )
                    : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  resource,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  )),
              const SizedBox(height: 16),
            ],
            if (career.commonMistakes.isNotEmpty) ...[
              _buildSectionTitle('Common Mistakes to Avoid'),
              const SizedBox(height: 8),
              ...career.commonMistakes.map((mistake) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning,
                          size: 20,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            mistake,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            if (career.salaryRange != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Salary Range: ${career.salaryRange}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryOrange,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  bool _isDirectVideoUrl(String url) {
    if (!_isValidUrl(url)) return false;
    final lowerUrl = url.toLowerCase();
    // Only direct video file URLs, not YouTube/Vimeo (those need web view)
    return lowerUrl.contains('.mp4') ||
        lowerUrl.contains('.mov') ||
        lowerUrl.contains('.avi') ||
        lowerUrl.contains('.m3u8') ||
        lowerUrl.contains('.webm');
  }

  bool _isVideoPlatformUrl(String url) {
    if (!_isValidUrl(url)) return false;
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('youtube.com') ||
        lowerUrl.contains('youtu.be') ||
        lowerUrl.contains('vimeo.com');
  }

  void _openResource(BuildContext context, String resource) {
    // Check if it's a valid URL first
    if (!_isValidUrl(resource)) {
      // Show a dialog or snackbar for invalid URLs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This resource is not a valid web link:\n"$resource"',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange[700],
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      return;
    }

    // Direct video files go to video player
    if (_isDirectVideoUrl(resource)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoUrl: resource,
            title: 'Video Resource',
          ),
        ),
      );
    } else {
      // YouTube, Vimeo, and other URLs go to web view
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GlobalWebViewScreen(
            url: resource,
            title: _isVideoPlatformUrl(resource) ? 'Video' : 'Resource',
          ),
        ),
      );
    }
  }
}

