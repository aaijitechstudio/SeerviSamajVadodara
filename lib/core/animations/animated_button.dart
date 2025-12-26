import 'package:flutter/material.dart';
import 'animation_constants.dart';

/// Animated button with press animation and ripple effect
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool isLoading;
  final bool showSuccess;
  final Duration animationDuration;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
    this.isLoading = false,
    this.showSuccess = false,
    this.animationDuration = AnimationDurations.fast,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: AnimationValues.scaleNormal,
      end: AnimationValues.scalePressed,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationCurves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldReduceMotion = AnimationPreferences.shouldReduceMotion(context);

    Widget button = ElevatedButton(
      onPressed:
          widget.isLoading || widget.showSuccess ? null : widget.onPressed,
      style: widget.style,
      child: widget.isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.style?.foregroundColor?.resolve({}) ?? Colors.white,
                ),
              ),
            )
          : widget.showSuccess
              ? const Icon(Icons.check, size: 20)
              : widget.child,
    );

    if (shouldReduceMotion) {
      return button;
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
            child: button,
          );
        },
      ),
    );
  }
}
