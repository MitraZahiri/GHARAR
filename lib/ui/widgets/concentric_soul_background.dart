import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Reusable CustomPainter drawing graceful organic concentric resonance waves
/// symbolizing the connection of two souls in GHARAR.
class ConcentricSoulBackgroundPainter extends CustomPainter {
  final bool isDark;
  final double centerScaleX;
  final double centerScaleY;
  final double stepRadius;

  const ConcentricSoulBackgroundPainter({
    required this.isDark,
    this.centerScaleX = 0.45,
    this.centerScaleY = 0.35,
    this.stepRadius = 55.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeColor =
        isDark
            ? const Color(0xFF332F37).withValues(alpha: 0.35)
            : const Color(0xFFE4D8C5).withValues(alpha: 0.55);

    final paint =
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..isAntiAlias = true;

    final center = Offset(
      size.width * centerScaleX,
      size.height * centerScaleY,
    );
    final maxRadius =
        math.sqrt(size.width * size.width + size.height * size.height) * 0.95;

    for (double r = 80; r < maxRadius; r += stepRadius) {
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConcentricSoulBackgroundPainter oldDelegate) =>
      oldDelegate.isDark != isDark ||
      oldDelegate.centerScaleX != centerScaleX ||
      oldDelegate.centerScaleY != centerScaleY ||
      oldDelegate.stepRadius != stepRadius;
}

/// A sanctuary background container that paints concentric resonance soul lines
/// with adaptive light parchment / dark earth theme backgrounds.
class ConcentricSoulBackground extends StatelessWidget {
  final Widget child;
  final bool? isDark;
  final double centerScaleX;
  final double centerScaleY;

  const ConcentricSoulBackground({
    super.key,
    required this.child,
    this.isDark,
    this.centerScaleX = 0.45,
    this.centerScaleY = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark =
        isDark ?? (Theme.of(context).brightness == Brightness.dark);

    return Container(
      color:
          effectiveIsDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: ConcentricSoulBackgroundPainter(
                  isDark: effectiveIsDark,
                  centerScaleX: centerScaleX,
                  centerScaleY: centerScaleY,
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
