import 'package:flutter/material.dart';

/// Centralized responsive design utilities for mobile devices
/// Handles small phones (iPhone SE 1st gen, compact Androids),
/// standard phones (iPhone 13/14/15/16, Galaxy S series),
/// large phablets (Pro Max, Ultra), and short aspect ratios.
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Screen width breakpoints
  static const double smallPhoneMaxWidth = 360.0;
  static const double standardPhoneMaxWidth = 414.0;
  static const double largePhoneMaxWidth = 480.0;

  /// Screen height breakpoint for compact/legacy screens (e.g. iPhone SE 568px/667px)
  static const double shortScreenMaxHeight = 680.0;

  /// Returns true if screen width is 360px or less (e.g. iPhone SE 1st gen, small Androids)
  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width <= smallPhoneMaxWidth;
  }

  /// Returns true if screen height is 680px or less (e.g. iPhone SE, older iPhones/Androids)
  static bool isShortPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).height <= shortScreenMaxHeight;
  }

  /// Returns true if screen is a large phablet or foldable
  static bool isLargePhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width > standardPhoneMaxWidth;
  }

  /// Recommended horizontal screen padding based on device width
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= smallPhoneMaxWidth) return 14.0;
    if (width <= standardPhoneMaxWidth) return 18.0;
    return 22.0;
  }

  /// Adaptive spacing between vertical sections
  static double sectionSpacing(BuildContext context) {
    return isShortPhone(context) ? 14.0 : 20.0;
  }

  /// Adaptive card internal padding
  static EdgeInsets cardPadding(BuildContext context) {
    if (isSmallPhone(context)) {
      return const EdgeInsets.all(14.0);
    }
    return const EdgeInsets.all(20.0);
  }

  /// Clamps text scale to prevent OS accessibility font sizes from breaking fixed-height designs
  static TextScaler clampedTextScaler(BuildContext context, {double min = 0.85, double max = 1.3}) {
    return MediaQuery.textScalerOf(context).clamp(minScaleFactor: min, maxScaleFactor: max);
  }
}
