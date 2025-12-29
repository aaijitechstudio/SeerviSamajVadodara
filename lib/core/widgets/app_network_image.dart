import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';
import '../animations/shimmer_loading.dart';

/// Standardized network image widget with caching and placeholder
/// Uses CachedNetworkImage for optimal performance
class AppNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? placeholderColor;
  final int? cacheWidth;
  final int? cacheHeight;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.placeholderColor,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      placeholder: (context, url) => placeholder ??
          ShimmerLoading(
            baseColor: isDark
                ? AppColors.darkBorder
                : (placeholderColor ?? AppColors.grey200),
            highlightColor: isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.1)
                : AppColors.grey100,
            child: Container(
              width: width,
              height: height,
              color: isDark ? AppColors.darkBorder : AppColors.grey200,
            ),
          ),
      errorWidget: (context, url, error) => errorWidget ??
          Container(
            width: width,
            height: height,
            color: isDark ? AppColors.darkBorder : AppColors.grey200,
            child: Icon(
              Icons.broken_image,
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey500,
              size: DesignTokens.iconSizeXL,
            ),
          ),
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}

/// Circular network image (for avatars)
class AppCircularNetworkImage extends StatelessWidget {
  final String? url;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppCircularNetworkImage({
    super.key,
    this.url,
    this.radius = 24.0,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _buildPlaceholder(context);
    }

    return AppNetworkImage(
      url: url!,
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(radius),
      placeholder: placeholder,
      errorWidget: errorWidget ?? _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CircleAvatar(
      radius: radius,
      backgroundColor: isDark ? AppColors.darkBorder : AppColors.grey300,
      child: Icon(
        Icons.person,
        size: radius,
        color: isDark ? AppColors.darkTextSecondary : AppColors.grey500,
      ),
    );
  }
}

/// Network image with aspect ratio
class AppAspectRatioNetworkImage extends StatelessWidget {
  final String url;
  final double aspectRatio;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppAspectRatioNetworkImage({
    super.key,
    required this.url,
    this.aspectRatio = 16 / 9,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: AppNetworkImage(
        url: url,
        fit: fit,
        borderRadius: borderRadius,
        placeholder: placeholder,
        errorWidget: errorWidget,
      ),
    );
  }
}

