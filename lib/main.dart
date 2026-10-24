import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/localization/app_language.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/responsive_utils.dart';
import 'firebase_options.dart';
import 'providers/app_state_provider.dart';
import 'services/auth_service.dart';
import 'services/cloud_sync_service.dart';
import 'services/storage_service.dart';
import 'ui/screens/auth/auth_screen.dart';
import 'ui/screens/main_navigation_shell.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';
import 'ui/screens/onboarding/partner_invite_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await StorageService.init();

  AuthService? authService;
  CloudSyncService? cloudSync;
  if (_hasFirebaseConfig) {
    await Firebase.initializeApp(
      // On the web, sign-in runs through the app's own Hosting domain so
      // Safari (also as an iPhone home-screen app) keeps it first-party.
      options:
          kIsWeb
              ? DefaultFirebaseOptions.web.copyWith(
                authDomain: 'gharar-aead2.web.app',
              )
              : DefaultFirebaseOptions.currentPlatform,
    );
    final auth = FirebaseAuth.instance;
    authService = AuthService(firebaseAuth: auth);
    cloudSync = CloudSyncService(
      firestore: FirebaseFirestore.instance,
      auth: auth,
    );
  }

  runApp(
    ChangeNotifierProvider(
      create:
          (_) => AppStateProvider(
            storageService,
            authService: authService,
            cloudSync: cloudSync,
          ),
      child: const GhararApp(),
    ),
  );
}

/// `flutterfire configure` set up Android, iOS and web; desktop builds
/// keep working with local storage only.
bool get _hasFirebaseConfig =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

class GhararApp extends StatefulWidget {
  const GhararApp({super.key});

  @override
  State<GhararApp> createState() => _GhararAppState();
}

class _GhararAppState extends State<GhararApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Keeps ThemeMode.system in step with the device's light/dark setting.
  @override
  void didChangePlatformBrightness() {
    context.read<AppStateProvider>().setPlatformBrightness(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<AppStateProvider, bool>(
      (p) => p.isDarkMode,
    );
    final locale = context.select<AppStateProvider, Locale>((p) => p.locale);
    final isAuthenticated = context.select<AppStateProvider, bool>(
      (p) => p.isAuthenticated,
    );
    final hasOnboarded = context.select<AppStateProvider, bool>(
      (p) => p.hasOnboarded,
    );
    final isPartnerLinked = context.select<AppStateProvider, bool>(
      (p) => p.isPartnerLinked,
    );

    return MaterialApp(
      title: 'GHARAR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      supportedLocales:
          AppLanguage.supportedLanguages
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
      home:
          !isAuthenticated
              ? const AuthScreen()
              : !hasOnboarded
              ? const OnboardingScreen()
              : !isPartnerLinked
              ? const PartnerInviteScreen()
              : const MainNavigationShell(),
    );
  }
}
