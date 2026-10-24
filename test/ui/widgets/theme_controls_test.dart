import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/ui/widgets/theme_mode_card.dart';
import 'package:gharar/ui/widgets/theme_toggle_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = AppStateProvider(
      StorageService(await SharedPreferences.getInstance()),
    );
  });

  Widget host(Widget child) {
    return ChangeNotifierProvider<AppStateProvider>.value(
      value: provider,
      child: MaterialApp(home: Scaffold(body: Center(child: child))),
    );
  }

  group('ThemeModeCard', () {
    testWidgets('offers system, light and dark choices', (tester) async {
      await tester.pumpWidget(host(const ThemeModeCard()));

      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('selecting a mode updates the provider', (tester) async {
      await tester.pumpWidget(host(const ThemeModeCard()));

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(provider.themeMode, ThemeMode.dark);

      await tester.tap(find.text('System'));
      await tester.pumpAndSettle();
      expect(provider.themeMode, ThemeMode.system);
    });

    testWidgets('uses the selected language', (tester) async {
      provider.setLanguageCode('tr');
      await tester.pumpWidget(host(const ThemeModeCard()));

      expect(find.text('Görünüm'), findsOneWidget);
      expect(find.text('Koyu'), findsOneWidget);
    });
  });

  group('ThemeToggleButton', () {
    testWidgets('flips the visible theme', (tester) async {
      await tester.pumpWidget(host(const ThemeToggleButton()));
      expect(provider.isDarkMode, isFalse);
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pump();
      expect(provider.isDarkMode, isTrue);
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    });

    testWidgets('has an accessible tooltip and 48dp target', (tester) async {
      await tester.pumpWidget(host(const ThemeToggleButton()));

      expect(find.byTooltip('Switch light/dark theme'), findsOneWidget);
      final size = tester.getSize(find.byType(ThemeToggleButton));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    });
  });
}
