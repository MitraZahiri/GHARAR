import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/localization/app_language.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state_provider.dart';
import 'services/storage_service.dart';
import 'ui/screens/auth/auth_screen.dart';
import 'ui/screens/main_navigation_shell.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await StorageService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppStateProvider(storageService),
      child: const GhararApp(),
    ),
  );
}

class GhararApp extends StatelessWidget {
  const GhararApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();

    return MaterialApp(
      title: 'GHARAR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: provider.locale,
      supportedLocales: AppLanguage.supportedLanguages
          .map((lang) => Locale(lang.code))
          .toList(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final clampedScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.25,
        );
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedScaler),
          child: child ?? const SizedBox(),
        );
      },
      home: !provider.isAuthenticated
          ? const AuthScreen()
          : provider.hasOnboarded
              ? const MainNavigationShell()
              : const OnboardingScreen(),
    );
  }
}
