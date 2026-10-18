import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/ui/widgets/concentric_soul_background.dart';

void main() {
  group('ConcentricSoulBackground Widget & Painter Tests', () {
    testWidgets(
      'Renders child inside ConcentricSoulBackground with CustomPaint',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ConcentricSoulBackground(
                isDark: false,
                child: Text('Sanctuary Content'),
              ),
            ),
          ),
        );

        expect(find.text('Sanctuary Content'), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
        expect(find.byType(ConcentricSoulBackground), findsOneWidget);
      },
    );

    testWidgets('Painter shouldRepaint returns true when isDark toggles', (
      WidgetTester tester,
    ) async {
      const painterLight = ConcentricSoulBackgroundPainter(isDark: false);
      const painterDark = ConcentricSoulBackgroundPainter(isDark: true);
      const painterLightSame = ConcentricSoulBackgroundPainter(isDark: false);

      expect(painterLight.shouldRepaint(painterDark), isTrue);
      expect(painterLight.shouldRepaint(painterLightSame), isFalse);
    });

    testWidgets(
      'ConcentricSoulBackground renders in dark mode without crashing',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ConcentricSoulBackground(
                isDark: true,
                child: SizedBox(width: 300, height: 600),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });
}
