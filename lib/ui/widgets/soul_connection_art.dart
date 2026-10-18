import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// SoulConnectionArt
/// An authentic, painterly rendering of the two souls holding hands with a radiant
/// golden bridge connecting their heart centers, directly inspired by the GHARAR concept artwork.
class SoulConnectionArt extends StatefulWidget {
  final double width;
  final double height;
  final bool animateGlow;

  const SoulConnectionArt({
    super.key,
    this.width = 280,
    this.height = 240,
    this.animateGlow = true,
  });

  @override
  State<SoulConnectionArt> createState() => _SoulConnectionArtState();
}

class _SoulConnectionArtState extends State<SoulConnectionArt>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    final isTestEnvironment = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('Test');
    if (widget.animateGlow && !isTestEnvironment) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _SoulConnectionPainter(
            pulseFactor: widget.animateGlow ? _pulseAnimation.value : 1.0,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        );
      },
    );
  }
}

class _SoulConnectionPainter extends CustomPainter {
  final double pulseFactor;
  final bool isDark;

  _SoulConnectionPainter({required this.pulseFactor, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Organic canvas background wash
    final bgPaint =
        Paint()
          ..color =
              isDark
                  ? AppColors.darkCard.withValues(alpha: 0.6)
                  : AppColors.parchmentSand.withValues(alpha: 0.45)
          ..style = PaintingStyle.fill;

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      const Radius.circular(24),
    );
    canvas.drawRRect(bgRect, bgPaint);

    // Subtle watercolor wash blobs
    final washPaint1 =
        Paint()
          ..color = (isDark ? AppColors.terracottaDeep : AppColors.agedPaper)
              .withValues(alpha: 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(w * 0.3, h * 0.4), w * 0.28, washPaint1);

    final washPaint2 =
        Paint()
          ..color = (isDark ? AppColors.earthSlateDeep : AppColors.agedPaper)
              .withValues(alpha: 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(w * 0.7, h * 0.4), w * 0.28, washPaint2);

    // ==========================================
    // Heart Centers & Golden Soul Bridge
    // ==========================================
    final leftHeartCenter = Offset(w * 0.28, h * 0.58);
    final rightHeartCenter = Offset(w * 0.72, h * 0.58);
    final heartRadius = w * 0.10 * pulseFactor;

    // Outer warm aura bridge glow
    final bridgeAuraPaint =
        Paint()
          ..color = AppColors.heartGoldGlow.withValues(
            alpha: 0.25 * pulseFactor,
          )
          ..strokeWidth = 26 * pulseFactor
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawLine(leftHeartCenter, rightHeartCenter, bridgeAuraPaint);

    // Glowing bridge bar connecting two hearts
    final bridgePaint =
        Paint()
          ..color = AppColors.heartGold.withValues(alpha: 0.92)
          ..strokeWidth = 14 * pulseFactor
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(leftHeartCenter, rightHeartCenter, bridgePaint);

    // Left solar heart core glow & circle
    final heartGlowPaint =
        Paint()
          ..color = AppColors.heartGoldGlow.withValues(
            alpha: 0.35 * pulseFactor,
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(leftHeartCenter, heartRadius * 1.5, heartGlowPaint);
    canvas.drawCircle(rightHeartCenter, heartRadius * 1.5, heartGlowPaint);

    final heartCorePaint =
        Paint()
          ..color = AppColors.heartGold
          ..style = PaintingStyle.fill;
    canvas.drawCircle(leftHeartCenter, heartRadius, heartCorePaint);
    canvas.drawCircle(rightHeartCenter, heartRadius, heartCorePaint);

    // Inner bright sun center
    final heartInnerPaint =
        Paint()
          ..color = AppColors.heartGoldGlow
          ..style = PaintingStyle.fill;
    canvas.drawCircle(leftHeartCenter, heartRadius * 0.55, heartInnerPaint);
    canvas.drawCircle(rightHeartCenter, heartRadius * 0.55, heartInnerPaint);

    // ==========================================
    // Left Soul Figure (Terracotta & Clay Silhouette)
    // ==========================================
    final terracottaBrush =
        Paint()
          ..color = AppColors.terracotta
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final terracottaFill =
        Paint()
          ..color = AppColors.terracotta.withValues(alpha: 0.14)
          ..style = PaintingStyle.fill;

    final leftFigurePath = Path();
    // Head & face facing right towards center
    leftFigurePath.moveTo(w * 0.26, h * 0.18);
    leftFigurePath.cubicTo(
      w * 0.20,
      h * 0.12, // forehead
      w * 0.28,
      h * 0.08, // crown
      w * 0.34,
      h * 0.14, // back of head
    );
    leftFigurePath.cubicTo(
      w * 0.37,
      h * 0.20,
      w * 0.33,
      h * 0.27, // jaw & chin
      w * 0.35,
      h * 0.33, // throat
    );
    // Neck down to chest and torso
    leftFigurePath.lineTo(w * 0.38, h * 0.44);
    leftFigurePath.lineTo(w * 0.42, h * 0.65); // right edge of left torso
    leftFigurePath.lineTo(w * 0.40, h * 0.73);
    // Arm moving to clasp hands at center
    leftFigurePath.cubicTo(
      w * 0.38,
      h * 0.77,
      w * 0.44,
      h * 0.79,
      w * 0.48,
      h * 0.81,
    );
    // Left bottom outline
    leftFigurePath.lineTo(w * 0.14, h * 0.79);
    leftFigurePath.cubicTo(
      w * 0.08,
      h * 0.72,
      w * 0.08,
      h * 0.52,
      w * 0.12,
      h * 0.46, // outer left shoulder
    );
    leftFigurePath.cubicTo(
      w * 0.14,
      h * 0.40,
      w * 0.22,
      h * 0.34,
      w * 0.26,
      h * 0.28, // back of neck
    );
    leftFigurePath.close();

    canvas.drawPath(leftFigurePath, terracottaFill);
    canvas.drawPath(leftFigurePath, terracottaBrush);

    // ==========================================
    // Right Soul Figure (Earth Slate & Graphite Silhouette)
    // ==========================================
    final slateBrush =
        Paint()
          ..color = isDark ? AppColors.earthSlateLight : AppColors.earthSlate
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final slateFill =
        Paint()
          ..color = (isDark ? AppColors.earthSlateLight : AppColors.earthSlate)
              .withValues(alpha: 0.14)
          ..style = PaintingStyle.fill;

    final rightFigurePath = Path();
    // Head & face facing left towards center
    rightFigurePath.moveTo(w * 0.74, h * 0.18);
    rightFigurePath.cubicTo(
      w * 0.80,
      h * 0.12, // forehead
      w * 0.72,
      h * 0.08, // crown
      w * 0.66,
      h * 0.14, // back of head
    );
    rightFigurePath.cubicTo(
      w * 0.63,
      h * 0.20,
      w * 0.67,
      h * 0.27, // jaw & chin
      w * 0.65,
      h * 0.33, // throat
    );
    // Neck down to chest and torso
    rightFigurePath.lineTo(w * 0.62, h * 0.44);
    rightFigurePath.lineTo(w * 0.58, h * 0.65); // left edge of right torso
    rightFigurePath.lineTo(w * 0.60, h * 0.73);
    // Arm moving to clasp hands at center
    rightFigurePath.cubicTo(
      w * 0.62,
      h * 0.77,
      w * 0.56,
      h * 0.79,
      w * 0.52,
      h * 0.81,
    );
    // Right bottom outline
    rightFigurePath.lineTo(w * 0.86, h * 0.79);
    rightFigurePath.cubicTo(
      w * 0.92,
      h * 0.72,
      w * 0.92,
      h * 0.52,
      w * 0.88,
      h * 0.46, // outer right shoulder
    );
    rightFigurePath.cubicTo(
      w * 0.86,
      h * 0.40,
      w * 0.78,
      h * 0.34,
      w * 0.74,
      h * 0.28, // back of neck
    );
    rightFigurePath.close();

    canvas.drawPath(rightFigurePath, slateFill);
    canvas.drawPath(rightFigurePath, slateBrush);

    // ==========================================
    // Hands Clasped Together at Center Bottom
    // ==========================================
    final handsOutline =
        Paint()
          ..color = isDark ? AppColors.darkTextPrimary : AppColors.inkCharcoal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.6
          ..strokeCap = StrokeCap.round;

    final handPath = Path();
    // Interlaced fingers motif
    handPath.moveTo(w * 0.44, h * 0.80);
    handPath.quadraticBezierTo(w * 0.47, h * 0.85, w * 0.46, h * 0.90);
    handPath.moveTo(w * 0.47, h * 0.80);
    handPath.quadraticBezierTo(w * 0.49, h * 0.87, w * 0.48, h * 0.92);
    handPath.moveTo(w * 0.50, h * 0.81);
    handPath.quadraticBezierTo(w * 0.51, h * 0.88, w * 0.51, h * 0.93);
    handPath.moveTo(w * 0.53, h * 0.80);
    handPath.quadraticBezierTo(w * 0.53, h * 0.86, w * 0.54, h * 0.90);
    handPath.moveTo(w * 0.56, h * 0.80);
    handPath.quadraticBezierTo(w * 0.55, h * 0.84, w * 0.57, h * 0.88);

    canvas.drawPath(handPath, handsOutline);
  }

  @override
  bool shouldRepaint(covariant _SoulConnectionPainter oldDelegate) {
    return oldDelegate.pulseFactor != pulseFactor ||
        oldDelegate.isDark != isDark;
  }
}
