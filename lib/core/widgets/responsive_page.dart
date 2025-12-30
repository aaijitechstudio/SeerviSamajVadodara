import 'package:flutter/material.dart';
import '../utils/safe_area_helper.dart';

/// A minimal, non-breaking responsive wrapper.
///
/// Goals:
/// - Keep phone UI unchanged by default
/// - Improve tablet/desktop readability by constraining max content width
/// - Provide consistent SafeArea + optional padding
///
/// Usage:
///   body: ResponsivePage(child: YourExistingBody())
class ResponsivePage extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxContentWidth;
  final bool useSafeArea;
  final bool handleBottomSafeArea;

  const ResponsivePage({
    super.key,
    required this.child,
    this.padding,
    this.maxContentWidth = 600,
    this.useSafeArea = true,
    this.handleBottomSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        handleBottomSafeArea ? SafeAreaHelper.getSafeBottomPadding(context) : 0.0;

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        // Only constrain on wider screens; phones remain unaffected.
        final shouldConstrain = constraints.maxWidth >= (maxContentWidth + 40);

        final constrained = shouldConstrain
            ? Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: child,
                ),
              )
            : child;

        final base = padding != null ? Padding(padding: padding!, child: constrained) : constrained;

        // Manual bottom handling to avoid content going under Android navigation buttons
        // and to account for keyboard height when it is visible.
        if (bottomInset > 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: base,
          );
        }

        return base;
      },
    );

    if (useSafeArea) {
      // We handle bottom safe area manually via SafeAreaHelper to cover both
      // system navigation bar and keyboard insets.
      content = SafeArea(bottom: false, child: content);
    }

    return content;
  }
}


