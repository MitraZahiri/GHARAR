import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/providers/app_state_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<StorageService> storageWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return StorageService(await SharedPreferences.getInstance());
  }

  group('StorageService theme mode', () {
    test('defaults to system when nothing is stored', () async {
      final storage = await storageWith({});
      expect(storage.themeMode, ThemeMode.system);
    });

    test('persists the chosen mode', () async {
      final storage = await storageWith({});
      await storage.setThemeMode(ThemeMode.dark);
      expect(storage.themeMode, ThemeMode.dark);
      await storage.setThemeMode(ThemeMode.light);
      expect(storage.themeMode, ThemeMode.light);
    });

    test('migrates the legacy dark-mode flag', () async {
      expect(
        (await storageWith({'gharar_theme_dark': true})).themeMode,
        ThemeMode.dark,
      );
      expect(
        (await storageWith({'gharar_theme_dark': false})).themeMode,
        ThemeMode.light,
      );
    });
  });

  group('AppStateProvider theme mode', () {
    test('system mode follows the platform brightness', () async {
      final provider = AppStateProvider(await storageWith({}));
      expect(provider.themeMode, ThemeMode.system);

      provider.setPlatformBrightness(Brightness.light);
      expect(provider.isDarkMode, isFalse);

      provider.setPlatformBrightness(Brightness.dark);
      expect(provider.isDarkMode, isTrue);
    });

    test('explicit modes ignore the platform brightness', () async {
      final storage = await storageWith({});
      final provider = AppStateProvider(storage);

      provider.setPlatformBrightness(Brightness.dark);
      provider.setThemeMode(ThemeMode.light);
      expect(provider.isDarkMode, isFalse);
      expect(storage.themeMode, ThemeMode.light);

      provider.setPlatformBrightness(Brightness.light);
      provider.setThemeMode(ThemeMode.dark);
      expect(provider.isDarkMode, isTrue);
      expect(storage.themeMode, ThemeMode.dark);
    });

    test('toggleTheme flips the visible theme to an explicit mode', () async {
      final provider = AppStateProvider(await storageWith({}));
      provider.setPlatformBrightness(Brightness.dark);

      provider.toggleTheme();
      expect(provider.themeMode, ThemeMode.light);
      expect(provider.isDarkMode, isFalse);

      provider.toggleTheme();
      expect(provider.themeMode, ThemeMode.dark);
    });

    test('notifies listeners only when the visible state changes', () async {
      final provider = AppStateProvider(await storageWith({}));
      provider.setThemeMode(ThemeMode.dark);
      var calls = 0;
      provider.addListener(() => calls++);

      provider.setPlatformBrightness(Brightness.dark);
      provider.setPlatformBrightness(Brightness.light);
      expect(calls, 0);

      provider.setThemeMode(ThemeMode.system);
      expect(calls, 1);
    });
  });
}
