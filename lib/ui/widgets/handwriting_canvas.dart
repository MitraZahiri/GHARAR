import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// One continuous finger stroke on the handwriting canvas.
class HandStroke {
  final List<Offset> points;
  final Color color;
  final double width;

  HandStroke({required Offset start, required this.color, required this.width})
    : points = [start];
}

/// Holds the strokes of a handwritten note and renders them to PNG.
class HandwritingController extends ChangeNotifier {
  final double strokeWidth;
  final List<HandStroke> _strokes = [];
  Color _inkColor;

  HandwritingController({
    Color inkColor = const Color(0xFF4A1E24),
    this.strokeWidth = 3.5,
  }) : _inkColor = inkColor;

  List<HandStroke> get strokes => List.unmodifiable(_strokes);
  bool get isEmpty => _strokes.isEmpty;

  Color get inkColor => _inkColor;
  set inkColor(Color color) {
    if (color == _inkColor) return;
    _inkColor = color;
    notifyListeners();
  }

  void startStroke(Offset point) {
    _strokes.add(
      HandStroke(start: point, color: _inkColor, width: strokeWidth),
    );
    notifyListeners();
  }

  void extendStroke(Offset point) {
    if (_strokes.isEmpty) return;
    _strokes.last.points.add(point);
    notifyListeners();
  }

  void endStroke() => notifyListeners();

  void undo() {
    if (_strokes.isEmpty) return;
    _strokes.removeLast();
    notifyListeners();
  }

  void clear() {
    if (_strokes.isEmpty) return;
    _strokes.clear();
    notifyListeners();
  }

  /// Renders the strokes on [background] as PNG bytes of [size] logical px.
  Future<Uint8List> toPngBytes(
    Size size, {
    required Color background,
    double pixelRatio = 3,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    paintStrokes(canvas, _strokes);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (size.width * pixelRatio).ceil(),
      (size.height * pixelRatio).ceil(),
    );
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('PNG encoding failed');
      return data.buffer.asUint8List();
    } finally {
      image.dispose();
      picture.dispose();
    }
  }
}

/// Draws [strokes] with rounded, smoothed ink.
void paintStrokes(Canvas canvas, List<HandStroke> strokes) {
  for (final stroke in strokes) {
    final paint =
        Paint()
          ..color = stroke.color
          ..strokeWidth = stroke.width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;
    final points = stroke.points;
    if (points.length == 1) {
      canvas.drawCircle(
        points.first,
        stroke.width / 2,
        paint..style = PaintingStyle.fill,
      );
      continue;
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length - 1; i++) {
      final mid = (points[i] + points[i + 1]) / 2;
      path.quadraticBezierTo(points[i].dx, points[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, paint);
  }
}

/// A finger-drawing surface. Claims drags immediately so a surrounding
/// scroll view or bottom sheet does not steal vertical strokes.
class HandwritingCanvas extends StatelessWidget {
  final HandwritingController controller;
  final String semanticLabel;

  const HandwritingCanvas({
    super.key,
    required this.controller,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ClipRect(
        child: RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: {
            _ImmediatePanRecognizer:
                GestureRecognizerFactoryWithHandlers<_ImmediatePanRecognizer>(
                  _ImmediatePanRecognizer.new,
                  (recognizer) {
                    recognizer.dragStartBehavior = DragStartBehavior.down;
                    recognizer.onStart = (d) {
                      controller.startStroke(d.localPosition);
                    };
                    recognizer.onUpdate = (d) {
                      controller.extendStroke(d.localPosition);
                    };
                    recognizer.onEnd = (_) => controller.endStroke();
                  },
                ),
          },
          child: CustomPaint(
            painter: _HandwritingPainter(controller),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _ImmediatePanRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}

class _HandwritingPainter extends CustomPainter {
  final HandwritingController controller;

  _HandwritingPainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) =>
      paintStrokes(canvas, controller.strokes);

  @override
  bool shouldRepaint(_HandwritingPainter oldDelegate) =>
      oldDelegate.controller != controller;
}
