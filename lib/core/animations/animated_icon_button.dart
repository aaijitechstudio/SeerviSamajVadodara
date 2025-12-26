import 'package:flutter/material.dart';
import 'animation_constants.dart';

/// Animated icon button with rotation and scale effects
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double? iconSize;
  final bool rotateOnTap;
  final Duration? rotationDuration;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.iconSize,
    this.rotateOnTap = false,
    this.rotationDuration,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationDurations.fast,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: AnimationValues.scaleNormal,
      end: AnimationValues.scalePressed,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationCurves.easeOut,
    ));

    if (widget.rotateOnTap) {
      _rotationAnimation = Tween<double>(
        begin: 0.0,
        end: 0.5, // 180 degrees
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: AnimationCurves.easeInOut,
      ));
    } else {
      _rotationAnimation = AlwaysStoppedAnimation(0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      if (widget.rotateOnTap) {
        _controller.forward().then((_) {
          if (mounted) {
            _controller.reverse();
          }
        });
      } else {
        _controller.forward().then((_) {
          if (mounted) {
            _controller.reverse();
          }
        });
      }
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldReduceMotion = AnimationPreferences.shouldReduceMotion(context);

    Widget iconButton = IconButton(
      icon: Icon(widget.icon),
      onPressed: widget.onPressed != null ? _handleTap : null,
      tooltip: widget.tooltip,
      color: widget.color,
      iconSize: widget.iconSize,
    );

    if (shouldReduceMotion) {
      return iconButton;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 3.14159, // Convert to radians
            child: iconButton,
          ),
        );
      },
    );
  }
}
