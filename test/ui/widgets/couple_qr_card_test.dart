import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/core/theme/app_theme.dart';
import 'package:gharar/ui/widgets/couple_qr_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

Widget _wrap(Widget child, {bool isDark = false}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('CoupleQrCard Widget Tests', () {
    testWidgets('Renders QR Image and invite code text correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const CoupleQrCard(
            inviteCode: 'GHARAR-7842-LOVE',
            isDark: false,
            isTr: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text('GHARAR-7842-LOVE'), findsOneWidget);
      expect(find.textContaining('QR Kodu Okutun'), findsOneWidget);
    });

    testWidgets('Renders in dark theme without overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const CoupleQrCard(
            inviteCode: 'GHARAR-9999-SOUL',
            isDark: true,
            isTr: false,
          ),
          isDark: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text('GHARAR-9999-SOUL'), findsOneWidget);
      expect(find.textContaining('Scan with Partner Phone'), findsOneWidget);
    });
  });
}
