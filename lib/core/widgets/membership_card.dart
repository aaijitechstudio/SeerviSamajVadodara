import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Membership Card Widget
/// Displays member information in a card format similar to the reference design
/// Adapts to app theme colors (primaryOrange, etc.)
/// Enhanced with animations and dynamic UI elements
class MembershipCard extends StatefulWidget {
  final String name;
  final String? samajId; // Samaj ID
  final String? role; // Role/Position (e.g., "सदस्य", "प्रचारक", "President")
  final String? location; // Location/Address
  final String? profileImageUrl;
  final String? gotra;
  final bool isVerified;
  final bool isCommitteeMember;
  final VoidCallback? onTap;
  final int index; // For staggered animation

  const MembershipCard({
    super.key,
    required this.name,
    this.samajId,
    this.role,
    this.location,
    this.profileImageUrl,
    this.gotra,
    this.isVerified = false,
    this.isCommitteeMember = false,
    this.onTap,
    this.index = 0,
  });

  @override
  State<MembershipCard> createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600 + (widget.index * 50)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) {
              setState(() => _isPressed = false);
              widget.onTap?.call();
            },
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedBuilder(
              animation: _borderAnimation,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
                  margin: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    bottom: DesignTokens.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                    border: Border.all(
                      color: AppColors.primaryOrange.withValues(
                        alpha: 0.1 + (_borderAnimation.value * 0.2),
                      ),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : AppColors.shadowMedium,
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.primaryOrange.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section with Logo and Organization Name
                      _buildHeader(context, isDark),

                      const SizedBox(height: DesignTokens.spacingS),

                      // Main Content Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingM),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Image Card with Decorative Background
                            _buildProfileImageCard(context, isDark),

                            const SizedBox(width: DesignTokens.spacingM),

                            // Member Details
                            Expanded(
                              child: _buildMemberDetails(context, isDark, l10n),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: DesignTokens.spacingS),

                      // Footer Section
                      _buildFooter(context, isDark),

                      const SizedBox(height: DesignTokens.spacingXS),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingM,
            vertical: DesignTokens.spacingXS,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryOrange
                    .withValues(alpha: 0.1 + (_borderAnimation.value * 0.05)),
                AppColors.primaryOrangeLight
                    .withValues(alpha: 0.05 + (_borderAnimation.value * 0.03)),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(DesignTokens.radiusL),
              topRight: Radius.circular(DesignTokens.radiusL),
            ),
          ),
          child: Row(
            children: [
              // Logo with animated glow
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryOrange.withValues(alpha: 0.2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange
                              .withValues(alpha: 0.3 * _fadeAnimation.value),
                          blurRadius: 8 * _fadeAnimation.value,
                          spreadRadius: 2 * _fadeAnimation.value,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/seervisamajvadodara.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.people,
                            color: AppColors.primaryOrange,
                            size: DesignTokens.iconSizeM,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: DesignTokens.spacingS),
              // Organization Name
              Expanded(
                child: Text(
                  l10n != null
                      ? '${l10n.samajTitle} ${l10n.samajVadodara}'
                      : 'Seervi Kshatriya Samaj Vadodara',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeL,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: AppColors.primaryOrange,
                    shadows: [
                      Shadow(
                        color: AppColors.primaryOrange.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImageCard(BuildContext context, bool isDark) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (_scaleAnimation.value * 0.1),
          child: Stack(
            children: [
              // Decorative Background Card with animated gradient
              Container(
                width: 110,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryOrangeDark.withValues(alpha: 0.8),
                      AppColors.primaryOrange.withValues(alpha: 0.9),
                      AppColors.primaryOrangeDark.withValues(alpha: 0.7),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange
                          .withValues(alpha: 0.3 * _fadeAnimation.value),
                      blurRadius: 12 * _fadeAnimation.value,
                      offset: Offset(0, 4 * _fadeAnimation.value),
                      spreadRadius: 1 * _fadeAnimation.value,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  child: widget.profileImageUrl != null &&
                          widget.profileImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.profileImageUrl!,
                          fit: BoxFit.cover,
                          memCacheWidth: 200, // Limit memory usage
                          memCacheHeight: 200,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primaryOrange
                                      .withValues(alpha: 0.3),
                                  AppColors.primaryOrangeDark
                                      .withValues(alpha: 0.4),
                                ],
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.backgroundWhite,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              _buildDefaultProfileImage(),
                        )
                      : _buildDefaultProfileImage(),
                ),
              ),
              // Role Badge Overlapping Bottom-Left with animation
              if (widget.role != null && widget.role!.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-0.2, 0.2),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve:
                              const Interval(0.5, 1.0, curve: Curves.easeOut),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingS,
                          vertical: DesignTokens.spacingXS / 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.accentGold,
                              AppColors.secondarySaffron,
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(DesignTokens.radiusM),
                            topRight: Radius.circular(DesignTokens.radiusS),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.accentGold.withValues(alpha: 0.6),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.backgroundWhite,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                widget.role!,
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeS,
                                  fontWeight: DesignTokens.fontWeightBold,
                                  color: AppColors.backgroundWhite,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultProfileImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOrange.withValues(alpha: 0.3),
            AppColors.primaryOrangeDark.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: DesignTokens.iconSizeXL,
          color: AppColors.backgroundWhite.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge(AppLocalizations? l10n) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulseValue =
            (1.0 + (0.1 * (1.0 - _fadeAnimation.value))).clamp(1.0, 1.1);
        return Row(
          children: [
            Transform.scale(
              scale: pulseValue,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.successColor.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.verified,
                  size: 16,
                  color: AppColors.successColor,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingXS),
            Text(
              l10n != null ? l10n.verifiedMember : 'Verified',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeS,
                color: AppColors.successColor,
                fontWeight: DesignTokens.fontWeightMedium,
                shadows: [
                  Shadow(
                    color: AppColors.successColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMemberDetails(
      BuildContext context, bool isDark, AppLocalizations? l10n) {
    // Build name with Shree, Name, Ji, and Gotra
    String displayName = l10n != null
        ? '${l10n.shree} ${widget.name} ${l10n.ji}'
        : 'Shree ${widget.name} Ji';
    if (widget.gotra != null && widget.gotra!.isNotEmpty) {
      displayName = '$displayName ${widget.gotra}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Samaj ID with fade animation
        if (widget.samajId != null && widget.samajId!.isNotEmpty) ...[
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: Text(
                l10n != null
                    ? '${l10n.samajId}: ${widget.samajId}'
                    : 'Samaj ID: ${widget.samajId}',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeM,
                  fontWeight: DesignTokens.fontWeightSemiBold,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXS),
        ],

        // Member Name with Shree, Ji, and Gotra
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            displayName,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeXL,
              fontWeight: DesignTokens.fontWeightBold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              height: 1.2,
              shadows: [
                Shadow(
                  color: (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary)
                      .withValues(alpha: 0.1),
                  blurRadius: 2,
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: DesignTokens.spacingXS),

        // Role/Status Badge (if not already shown in profile card badge)
        if (widget.role != null &&
            widget.role!.isNotEmpty &&
            !widget.isCommitteeMember)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingM,
                vertical: DesignTokens.spacingXS / 2,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withValues(alpha: 0.15),
                    AppColors.primaryOrangeLight.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                border: Border.all(
                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.role!,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeS,
                  fontWeight: DesignTokens.fontWeightSemiBold,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
          ),

        // Location
        if (widget.location != null && widget.location!.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingS),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingXS),
                Expanded(
                  child: Text(
                    widget.location!.toUpperCase(),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeS,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      fontWeight: DesignTokens.fontWeightMedium,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Verified Badge with pulse animation
        if (widget.isVerified) ...[
          const SizedBox(height: DesignTokens.spacingS),
          _buildVerifiedBadge(l10n),
        ],
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Disclaimer
          // Attribution
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryOrange,
                        AppColors.primaryOrangeLight,
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingXS),
                Flexible(
                  child: Text(
                    l10n != null
                        ? 'Generated By - ${l10n.samajTitle} ${l10n.samajVadodara}'
                        : 'Generated By - Shree Seervi Samaj Vadodara',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXS,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
