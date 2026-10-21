import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/ui/widgets/handwriting_canvas.dart';

void main() {
  group('HandwritingController', () {
    test('tracks strokes, undo and clear', () {
      final controller = HandwritingController();
      expect(controller.isEmpty, isTrue);

      controller.startStroke(const Offset(1, 1));
      controller.extendStroke(const Offset(5, 5));
      controller.endStroke();
      controller.startStroke(const Offset(10, 10));
      controller.endStroke();
      expect(controller.strokes, hasLength(2));

      controller.undo();
      expect(controller.strokes, hasLength(1));

      controller.clear();
      expect(controller.isEmpty, isTrue);
      controller.dispose();
    });

    test('ink color applies to new strokes only', () {
      final controller = HandwritingController(inkColor: Colors.black);
      controller.startStroke(Offset.zero);
      controller.endStroke();
      controller.inkColor = Colors.red;
      controller.startStroke(Offset.zero);
      controller.endStroke();

      expect(controller.strokes.first.color, Colors.black);
      expect(controller.strokes.last.color, Colors.red);
      controller.dispose();
    });

    test('exports a PNG image', () async {
      final controller = HandwritingController();
      controller.startStroke(const Offset(2, 2));
      controller.extendStroke(const Offset(40, 30));
      controller.endStroke();

      final bytes = await controller.toPngBytes(
        const Size(60, 40),
        background: Colors.white,
        pixelRatio: 1,
      );

      // PNG signature: 0x89 'P' 'N' 'G'
      expect(bytes.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
      controller.dispose();
    });
  });

  testWidgets('dragging on the canvas records a stroke', (tester) async {
    final controller = HandwritingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: HandwritingCanvas(
                controller: controller,
                semanticLabel: 'Drawing area',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(HandwritingCanvas), const Offset(60, 40));
    await tester.pump();

    expect(controller.isEmpty, isFalse);
    expect(controller.strokes.single.points.length, greaterThan(1));
    expect(find.bySemanticsLabel('Drawing area'), findsOneWidget);
  });
}
