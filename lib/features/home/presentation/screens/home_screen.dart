import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../community/presentation/widgets/post_list_widget.dart';
import '../../../weather/providers/weather_provider.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/animations/animation_constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final weatherAsync = ref.watch(weatherProvider);

    // Get location from weather or use default
    final locationName = weatherAsync.when(
      data: (weather) => weather?.location ?? 'Vadodara',
      loading: () => 'Vadodara',
      error: (_, __) => 'Vadodara',
    );

    return Column(
      children: [
        _DynamicAppBar(
          locationName: locationName,
          onMenuPressed: () {
            final scaffoldState =
                context.findAncestorStateOfType<ScaffoldState>();
            scaffoldState?.openDrawer();
          },
          onNotificationPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.comingSoon)),
            );
          },
          notificationTooltip: l10n.notifications,
        ),
        const Expanded(
          child: PostListWidget(),
        ),
      ],
    );
  }
}

class _DynamicAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String locationName;
  final VoidCallback onMenuPressed;
  final VoidCallback onNotificationPressed;
  final String notificationTooltip;

  const _DynamicAppBar({
    required this.locationName,
    required this.onMenuPressed,
    required this.onNotificationPressed,
    required this.notificationTooltip,
  });

  @override
  State<_DynamicAppBar> createState() => _DynamicAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}

class _DynamicAppBarState extends State<_DynamicAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final shouldReduceMotion = AnimationPreferences.shouldReduceMotion(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.grey[900]!,
                  Colors.grey[800]!,
                ]
              : [
                  AppColors.primaryOrange.withValues(alpha: 0.1),
                  AppColors.primaryOrangeLight.withValues(alpha: 0.05),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.shadowLight,
            blurRadius: DesignTokens.elevationMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
          child: Row(
            children: [
              // Animated Menu Button
              _AnimatedMenuButton(
                onPressed: widget.onMenuPressed,
                shouldReduceMotion: shouldReduceMotion,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              // Logo and Title Section
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[800]
                            : AppColors.backgroundWhite,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusM),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.5)
                                : AppColors.shadowLight,
                            blurRadius: DesignTokens.elevationLow,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusM),
                        child: Image.asset(
                          'assets/images/samaj_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.people,
                              size: DesignTokens.iconSizeM,
                              color: AppColors.primaryOrange,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingS),
                    // Title with Location
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.samajTitle,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeL,
                              fontWeight: DesignTokens.fontWeightBold,
                              color:
                                  isDark ? Colors.white : AppColors.textPrimary,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: isDark
                                    ? AppColors.primaryOrangeLight
                                    : AppColors.primaryOrange,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  widget.locationName,
                                  style: TextStyle(
                                    fontSize: DesignTokens.fontSizeS,
                                    fontWeight: DesignTokens.fontWeightMedium,
                                    color: isDark
                                        ? AppColors.primaryOrangeLight
                                        : AppColors.primaryOrangeDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              // Notification Button
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey[800]!.withValues(alpha: 0.5)
                      : AppColors.backgroundWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : AppColors.shadowLight,
                      blurRadius: DesignTokens.elevationLow,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  tooltip: widget.notificationTooltip,
                  onPressed: widget.onNotificationPressed,
                  color: isDark
                      ? AppColors.primaryOrangeLight
                      : AppColors.primaryOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedMenuButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool shouldReduceMotion;

  const _AnimatedMenuButton({
    required this.onPressed,
    required this.shouldReduceMotion,
  });

  @override
  State<_AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<_AnimatedMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationCurves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.shouldReduceMotion) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.shouldReduceMotion) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
    widget.onPressed();
  }

  void _handleTapCancel() {
    if (!widget.shouldReduceMotion) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shouldReduceMotion) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryOrange,
              AppColors.primaryOrangeDark,
            ],
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: 0.3),
              blurRadius: DesignTokens.elevationMedium,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: widget.onPressed,
          color: Colors.white,
        ),
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryOrange,
                    AppColors.primaryOrangeDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withValues(alpha: 0.4),
                    blurRadius: _isPressed
                        ? DesignTokens.elevationLow
                        : DesignTokens.elevationMedium,
                    offset: Offset(0, _isPressed ? 1 : 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: widget.onPressed,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
