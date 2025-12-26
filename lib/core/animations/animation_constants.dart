import 'package:flutter/material.dart';

/// Animation duration constants for consistent timing across the app
class AnimationDurations {
  // Fast animations for immediate feedback
  static const Duration fast = Duration(milliseconds: 150);

  // Normal animations for standard transitions
  static const Duration normal = Duration(milliseconds: 300);

  // Slow animations for complex transitions
  static const Duration slow = Duration(milliseconds: 500);

  // Very slow animations for splash screens and major transitions
  static const Duration verySlow = Duration(milliseconds: 800);

  // Stagger delay for list animations
  static const Duration staggerDelay = Duration(milliseconds: 50);
}

/// Animation curve constants
class AnimationCurves {
  // Most common curve for buttons and cards
  static const Curve easeOut = Curves.easeOut;

  // Smooth transitions
  static const Curve easeInOut = Curves.easeInOut;

  // Playful animations (use sparingly)
  static const Curve elastic = Curves.elasticOut;

  // Linear for loading indicators
  static const Curve linear = Curves.linear;

  // Fast out slow in for material design
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // Decelerate for smooth stops
  static const Curve decelerate = Curves.decelerate;
}

/// Animation values for common transformations
class AnimationValues {
  // Scale values
  static const double scalePressed = 0.95;
  static const double scaleNormal = 1.0;
  static const double scaleHover = 1.05;

  // Opacity values
  static const double opacityHidden = 0.0;
  static const double opacityVisible = 1.0;
  static const double opacityDisabled = 0.5;

  // Translation offsets (in logical pixels)
  static const Offset slideUpOffset = Offset(0, 20);
  static const Offset slideDownOffset = Offset(0, -20);
  static const Offset slideLeftOffset = Offset(20, 0);
  static const Offset slideRightOffset = Offset(-20, 0);
}

/// Helper class to check if reduced motion is enabled
class AnimationPreferences {
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation ||
        MediaQuery.of(context).disableAnimations;
  }

  static Duration adjustDuration(BuildContext context, Duration duration) {
    if (shouldReduceMotion(context)) {
      return Duration.zero;
    }
    return duration;
  }
}
