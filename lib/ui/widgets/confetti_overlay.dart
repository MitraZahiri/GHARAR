import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool isPlaying;

  const ConfettiOverlay({
    super.key,
    required this.child,
    required this.isPlaying,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(() {
      setState(() {});
    });

    if (widget.isPlaying) {
      _startBurst();
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startBurst();
    }
  }

  void _startBurst() {
    _particles.clear();
    const colors = [
      AppColors.blushPinkDeep,
      AppColors.lavenderDeep,
      AppColors.coralGold,
      AppColors.champagneGold,
      AppColors.burgundyRose,
      Colors.pinkAccent,
    ];

    for (int i = 0; i < 45; i++) {
      _particles.add(
        _ConfettiParticle(
          x: 0.5 + (_rand.nextDouble() - 0.5) * 0.3,
          y: 0.3 + (_rand.nextDouble() - 0.5) * 0.2,
          vx: (_rand.nextDouble() - 0.5) * 1.6,
          vy: -_rand.nextDouble() * 1.5 - 0.5,
          color: colors[_rand.nextInt(colors.length)],
          size: _rand.nextDouble() * 10 + 6,
          rotation: _rand.nextDouble() * 2 * pi,
          rotationSpeed: (_rand.nextDouble() - 0.5) * 4,
          shape: _rand.nextBool() ? _ParticleShape.heart : _ParticleShape.petal,
        ),
      );
    }

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum _ParticleShape { heart, petal }

class _ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;
  double rotation;
  double rotationSpeed;
  _ParticleShape shape;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in particles) {
      final currentX =
          (p.x * size.width) + (p.vx * progress * size.width * 0.4);
      // Gravity effect
      final currentY =
          (p.y * size.height) +
          (p.vy * progress * size.height * 0.4) +
          (0.5 * 9.8 * pow(progress, 2) * size.height * 0.4);

      final currentRotation = p.rotation + (p.rotationSpeed * progress);

      final paint =
          Paint()
            ..color = p.color.withValues(alpha: opacity)
            ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRotation);

      if (p.shape == _ParticleShape.heart) {
        _drawHeart(canvas, paint, p.size);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.6,
            ),
            const Radius.circular(3),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  void _drawHeart(Canvas canvas, Paint paint, double size) {
    final path = Path();
    final s = size * 0.6;
    path.moveTo(0, s * 0.35);
    path.cubicTo(-s * 0.6, -s * 0.3, -s * 1.2, s * 0.4, 0, s * 1.1);
    path.cubicTo(s * 1.2, s * 0.4, s * 0.6, -s * 0.3, 0, s * 0.35);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
