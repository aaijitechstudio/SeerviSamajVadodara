import 'package:flutter/material.dart';
import 'animation_constants.dart';

/// Widget wrapper for staggered list item animations
class StaggeredListAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration? delay;
  final Duration? duration;
  final Curve? curve;

  const StaggeredListAnimation({
    super.key,
    required this.child,
    required this.index,
    this.delay,
    this.duration,
    this.curve,
  });

  @override
  Widget build(BuildContext context) {
    final shouldReduceMotion = AnimationPreferences.shouldReduceMotion(context);

    if (shouldReduceMotion) {
      return child;
    }

    final animationDelay = delay ?? (AnimationDurations.staggerDelay * index);
    final animationDuration = duration ?? AnimationDurations.normal;
    final animationCurve = curve ?? AnimationCurves.easeOut;

    return _StaggeredAnimationWrapper(
      delay: animationDelay,
      duration: animationDuration,
      curve: animationCurve,
      child: child,
    );
  }
}

class _StaggeredAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const _StaggeredAnimationWrapper({
    required this.child,
    required this.delay,
    required this.duration,
    required this.curve,
  });

  @override
  State<_StaggeredAnimationWrapper> createState() =>
      _StaggeredAnimationWrapperState();
}

class _StaggeredAnimationWrapperState extends State<_StaggeredAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: AnimationValues.opacityHidden,
      end: AnimationValues.opacityVisible,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: AnimationValues.slideUpOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
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
          child: widget.child,
        ),
      ),
    );
  }
}
