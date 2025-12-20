import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({super.key});

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.photoGallery,
        showLogo: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryOrange,
            unselectedLabelColor:
                Theme.of(context).textTheme.bodySmall?.color ??
                    AppColors.textSecondary,
            indicatorColor: AppColors.primaryOrange,
            tabs: [
              Tab(text: l10n.vadodaraPhotos),
              Tab(text: l10n.aaijiDarshan),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVadodaraPhotosTab(context, l10n),
                _buildAaijiDarshanTab(context, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVadodaraPhotosTab(BuildContext context, AppLocalizations l10n) {
    // Placeholder images - Replace with actual Vadodara photos from Firebase/API
    final List<String> vadodaraImages = [
      // Add your Vadodara photo URLs here
      // 'https://example.com/vadodara1.jpg',
      // 'https://example.com/vadodara2.jpg',
    ];

    if (vadodaraImages.isEmpty) {
      return _buildEmptyState(context, l10n, l10n.noVadodaraPhotosAvailable);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: DesignTokens.spacingM,
        mainAxisSpacing: DesignTokens.spacingM,
        childAspectRatio: 1.0,
      ),
      itemCount: vadodaraImages.length,
      itemBuilder: (context, index) {
        return _buildGalleryItem(context, vadodaraImages[index], index);
      },
    );
  }

  Widget _buildAaijiDarshanTab(BuildContext context, AppLocalizations l10n) {
    // List of 11 Aaiji Darshan images
    final List<String> aaijiDarshanImages = [
      'assets/images/aai_darshan-1.jpg',
      'assets/images/aai_darshan-2.jpg',
      'assets/images/aai_darshan-3.jpg',
      'assets/images/aai_darshan-4.jpg',
      'assets/images/aai_darshan-5.jpg',
      'assets/images/aai_darshan-6.jpg',
      'assets/images/aai_darshan-7.jpg',
      'assets/images/aai_darshan-8.jpg',
      'assets/images/aai_darshan-9.jpg',
      'assets/images/aai_darshan-10.jpg',
      'assets/images/aai_darshan-11.jpg',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aaiji Darshan Images - One per row
          ...aaijiDarshanImages.asMap().entries.map((entry) {
            final index = entry.key;
            final imagePath = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
              child: _buildAaijiDarshanImageItem(context, imagePath, index + 1),
            );
          }),
          const SizedBox(height: DesignTokens.spacingXL),
          // 11 Niyam Section
          _buildElevenNiyamSection(context, l10n),
        ],
      ),
    );
  }

  Widget _buildAaijiDarshanImageItem(
    BuildContext context,
    String imagePath,
    int imageNumber,
  ) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, imagePath, isAsset: true),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: DesignTokens.elevationMedium,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: AppColors.grey200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image,
                      color: AppColors.grey500,
                      size: DesignTokens.iconSizeXL,
                    ),
                    const SizedBox(height: DesignTokens.spacingS),
                    Text(
                      'Image $imageNumber',
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: DesignTokens.fontSizeM,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildElevenNiyamSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withValues(alpha: 0.1),
            AppColors.primaryOrangeLight.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                ),
                child: Icon(
                  Icons.rule,
                  color: AppColors.primaryOrange,
                  size: DesignTokens.iconSizeM,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Text(
                  l10n.elevenNiyamTitle,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeXL,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingL),
          _buildNiyamItem(context, l10n, 1, l10n.niyam1),
          _buildNiyamItem(context, l10n, 2, l10n.niyam2),
          _buildNiyamItem(context, l10n, 3, l10n.niyam3),
          _buildNiyamItem(context, l10n, 4, l10n.niyam4),
          _buildNiyamItem(context, l10n, 5, l10n.niyam5),
          _buildNiyamItem(context, l10n, 6, l10n.niyam6),
          _buildNiyamItem(context, l10n, 7, l10n.niyam7),
          _buildNiyamItem(context, l10n, 8, l10n.niyam8),
          _buildNiyamItem(context, l10n, 9, l10n.niyam9),
          _buildNiyamItem(context, l10n, 10, l10n.niyam10),
          _buildNiyamItem(context, l10n, 11, l10n.niyam11),
        ],
      ),
    );
  }

  Widget _buildNiyamItem(
    BuildContext context,
    AppLocalizations l10n,
    int number,
    String niyamText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: DesignTokens.fontSizeM,
                  fontWeight: DesignTokens.fontWeightBold,
                ),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: Text(
              niyamText,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeM,
                color: Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingXL),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: DesignTokens.iconSizeXL * 2,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXL),
            Text(
              message,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                fontWeight: DesignTokens.fontWeightBold,
                color: Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              l10n.photoGalleryEmptyMessage,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeM,
                color: Theme.of(context).textTheme.bodySmall?.color ??
                    AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, imageUrl, isAsset: false),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: DesignTokens.elevationMedium,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: AppColors.grey200,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.primaryOrange,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.grey200,
                child: Icon(
                  Icons.broken_image,
                  color: AppColors.grey500,
                  size: DesignTokens.iconSizeXL,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath,
      {required bool isAsset}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(DesignTokens.spacingM),
        child: Stack(
          children: [
            Center(
              child: isAsset
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(DesignTokens.spacingL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusM),
                          ),
                          child: Icon(
                            Icons.broken_image,
                            size: DesignTokens.iconSizeXL,
                            color: AppColors.grey500,
                          ),
                        );
                      },
                    )
                  : Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(DesignTokens.spacingL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusM),
                          ),
                          child: Icon(
                            Icons.broken_image,
                            size: DesignTokens.iconSizeXL,
                            color: AppColors.grey500,
                          ),
                        );
                      },
                    ),
            ),
            Positioned(
              top: DesignTokens.spacingM,
              right: DesignTokens.spacingM,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingXS),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
