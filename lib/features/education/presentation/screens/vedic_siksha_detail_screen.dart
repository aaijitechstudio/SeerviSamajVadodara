import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/vedic_sikhsa_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/screens/web_view_screen.dart';
import '../../../../core/screens/video_player_screen.dart';

class VedicSikshaDetailScreen extends StatelessWidget {
  final VedicSikshaDetail data;

  const VedicSikshaDetailScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        title: data.title,
        showLogo: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: data.heroImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 64,
                        color: AppColors.primaryOrange.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.title,
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              data.subtitle,
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              data.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle('मुख्य शिक्षाएँ'),
            ...data.keyPoints.map(_bulletPoint),

            const SizedBox(height: 24),

            _sectionTitle('चित्र संग्रह'),
            _imageGallery(data.imageGallery),

            const SizedBox(height: 24),

            _sectionTitle('अध्ययन सामग्री'),
            ...data.links.map((e) => _linkTile(context, e)),

            const SizedBox(height: 24),

            _sectionTitle('विडियो संसाधन'),
            ...data.videos.map((e) => _videoTile(context, e)),

            const SizedBox(height: 24),

            _disclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _imageGallery(List<String> images) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: images[index],
              width: 160,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 160,
                color: AppColors.primaryOrange.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 160,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.image_not_supported,
                  color: AppColors.primaryOrange.withOpacity(0.3),
                  size: 40,
                ),
              ),
            ),
          );
        },
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
    return lowerUrl.contains('.mp4') ||
        lowerUrl.contains('.mov') ||
        lowerUrl.contains('.avi') ||
        lowerUrl.contains('.m3u8') ||
        lowerUrl.contains('.webm');
  }

  Widget _linkTile(BuildContext context, ResourceLink link) {
    if (!_isValidUrl(link.url)) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.info_outline, color: Colors.grey),
        title: Text(
          link.title,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.link, color: AppColors.primaryOrange),
      title: Text(
        link.title,
        style: const TextStyle(
          color: AppColors.primaryOrange,
          decoration: TextDecoration.underline,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _openLink(context, link.url, link.title),
    );
  }

  Widget _videoTile(BuildContext context, ResourceLink link) {
    if (!_isValidUrl(link.url)) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.info_outline, color: Colors.grey),
        title: Text(
          link.title,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        _isDirectVideoUrl(link.url)
            ? Icons.play_circle_fill
            : Icons.video_library,
        color: AppColors.primaryOrange,
      ),
      title: Text(
        link.title,
        style: const TextStyle(
          color: AppColors.primaryOrange,
          decoration: TextDecoration.underline,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _openVideo(context, link.url, link.title),
    );
  }

  Widget _disclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'यह सामग्री केवल शैक्षिक एवं सांस्कृतिक जानकारी हेतु प्रदान की गई है। '
        'इसका उद्देश्य धार्मिक भावनाओं को ठेस पहुँचाना नहीं है।',
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  void _openLink(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GlobalWebViewScreen(
          url: url,
          title: title,
        ),
      ),
    );
  }

  void _openVideo(BuildContext context, String url, String title) {
    if (_isDirectVideoUrl(url)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoUrl: url,
            title: title,
          ),
        ),
      );
    } else {
      // YouTube/Vimeo URLs open in web view
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GlobalWebViewScreen(
            url: url,
            title: title,
          ),
        ),
      );
    }
  }
}
