import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final int index; // For staggered animation

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.index = 0,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 50)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: widget.margin ??
                const EdgeInsets.only(bottom: DesignTokens.spacingM),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Theme.of(context).cardColor,
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(DesignTokens.radiusL),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : AppColors.primaryOrange.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.05)
                      : AppColors.shadowLight,
                  blurRadius: widget.elevation ?? DesignTokens.elevationMedium,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(DesignTokens.radiusL),
                child: Padding(
                  padding: widget.padding ??
                      const EdgeInsets.all(DesignTokens.spacingL),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
