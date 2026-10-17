import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Ensures GHARAR delivers a native mobile app look and feel
/// On large screens (web, desktop, tablet), it centers a sleek phone canvas
/// with soft shadows, preserving ideal proportions and touch ergonomics.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 460,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= maxWidth) {
          return child;
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0F0A0E)
              : const Color(0xFFEDE3DC),
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.5,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
