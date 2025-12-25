import 'package:flutter/material.dart';
import '../../domain/models/skill_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/screens/web_view_screen.dart';
import '../../../../core/screens/video_player_screen.dart';

class SkillDetailScreen extends StatelessWidget {
  final SkillModel skill;

  const SkillDetailScreen({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        title: skill.title,
        showLogo: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.build,
                      color: AppColors.primaryOrange,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        skill.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  skill.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                if (skill.duration != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Duration: ${skill.duration}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (skill.whoShouldLearn.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Who Should Learn'),
                  const SizedBox(height: 8),
                  ...skill.whoShouldLearn.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              size: 20,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
                if (skill.freeResources.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Free Learning Resources'),
                  const SizedBox(height: 8),
                  ...skill.freeResources.map((resource) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _isValidUrl(resource)
                            ? InkWell(
                                onTap: () => _openResource(context, resource),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      _isVideoUrl(resource) ? Icons.play_circle_outline : Icons.link,
                                      size: 20,
                                      color: AppColors.primaryOrange,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        resource,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryOrange,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
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
                ],
                if (skill.careerOutcomes.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Career Outcomes'),
                  const SizedBox(height: 8),
                  ...skill.careerOutcomes.map((outcome) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.work,
                              size: 20,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                outcome,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
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

  bool _isVideoUrl(String url) {
    if (!_isValidUrl(url)) return false;
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('.mp4') ||
        lowerUrl.contains('.mov') ||
        lowerUrl.contains('.avi') ||
        lowerUrl.contains('youtube.com') ||
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

    if (_isVideoUrl(resource)) {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GlobalWebViewScreen(
            url: resource,
            title: 'Resource',
          ),
        ),
      );
    }
  }
}

