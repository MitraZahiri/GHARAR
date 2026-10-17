import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/core/theme/app_colors.dart';
import 'package:gharar/ui/widgets/custom_primary_button.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('CustomPrimaryButton Widget Tests', () {
    testWidgets('butonu doğru render etmeli ve verilen metni göstermelidir',
        (WidgetTester tester) async {
      const buttonText = 'Devam Et';

      await tester.pumpWidget(
        buildTestableWidget(
          CustomPrimaryButton(
            text: buttonText,
            onPressed: () {},
          ),
        ),
      );

      // Metnin ekranda olduğunu doğrula
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(CustomPrimaryButton), findsOneWidget);

      // Terracotta renginin kullanıldığını container dekorasyonundan doğrula
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CustomPrimaryButton),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, equals(AppColors.terracotta));
    });

    testWidgets('tıklandığında onPressed fonksiyonunu tetiklemelidir',
        (WidgetTester tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          CustomPrimaryButton(
            text: 'Onayla',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      );

      // Butona tıkla
      await tester.tap(find.byType(CustomPrimaryButton));
      await tester.pumpAndSettle();

      // Fonksiyonun çalıştığını doğrula
      expect(wasPressed, isTrue);
    });

    testWidgets('isLoading true olduğunda yüklenme göstergesi render etmeli ve tıklamayı engellemelidir',
        (WidgetTester tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          CustomPrimaryButton(
            text: 'Kaydet',
            isLoading: true,
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      );

      // Yükleme animasyonu gösterilmeli, metin gizlenmeli
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Kaydet'), findsNothing);

      // Tıklanmaya çalışıldığında fonksiyon tetiklenmemeli
      await tester.tap(find.byType(CustomPrimaryButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });
  });
}
