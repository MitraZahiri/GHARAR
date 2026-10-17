import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/localization/app_language.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/responsive_utils.dart';
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
    final isDarkMode =
        context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final locale =
        context.select<AppStateProvider, Locale>((p) => p.locale);
    final isAuthenticated =
        context.select<AppStateProvider, bool>((p) => p.isAuthenticated);
    final hasOnboarded =
        context.select<AppStateProvider, bool>((p) => p.hasOnboarded);

    return MaterialApp(
      title: 'GHARAR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
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
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: ResponsiveUtils.clampedTextScaler(
              context,
              min: 0.85,
              max: 1.25,
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
      home: !isAuthenticated
          ? const AuthScreen()
          : hasOnboarded
              ? const MainNavigationShell()
              : const OnboardingScreen(),
    );
  }
}
