import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gharar/core/localization/app_language.dart';
import 'package:gharar/core/localization/app_localizations.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/screens/auth/auth_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Unit Tests', () {
    late StorageService storage;
    late AppStateProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await StorageService.init();
      provider = AppStateProvider(storage);
    });

    test('Initial state is unauthenticated unless seeded', () {
      expect(provider.isAuthenticated, isFalse);
      expect(provider.authProvider, isNull);
      expect(provider.userEmail, isNull);
    });

    test('Sign in with Apple authenticates user with Apple ID provider', () async {
      await provider.signInWithApple();

      expect(provider.isAuthenticated, isTrue);
      expect(provider.authProvider, equals('apple'));
      expect(provider.userEmail, contains('appleid.com'));
      expect(provider.currentUser?.authProvider, equals('apple'));
    });

    test('Authenticate with Email sets user credentials and authenticates', () async {
      await provider.authenticateWithEmail(
        name: 'Leyla',
        email: 'leyla@example.com',
        password: 'securePassword123',
        isRegister: true,
      );

      expect(provider.isAuthenticated, isTrue);
      expect(provider.authProvider, equals('email'));
      expect(provider.userEmail, equals('leyla@example.com'));
      expect(provider.currentUser?.name, equals('Leyla'));
      expect(provider.currentUser?.email, equals('leyla@example.com'));
    });

    test('Sign in as Demo Couple sets authenticated and seeds Mitra & Deniz', () async {
      await provider.signInAsDemoCouple();

      expect(provider.isAuthenticated, isTrue);
      expect(provider.authProvider, equals('demo'));
      expect(provider.couple, isNotNull);
      expect(provider.couple?.partner1.name, equals('Mitra'));
      expect(provider.couple?.partner2?.name, equals('Deniz'));
    });

    test('Sign out clears authenticated state while retaining preferences', () async {
      await provider.signInWithApple();
      expect(provider.isAuthenticated, isTrue);

      await provider.signOut();
      expect(provider.isAuthenticated, isFalse);
    });
  });

  group('AuthScreen Responsive & Localization Widget Tests', () {
    late StorageService storage;
    late AppStateProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await StorageService.init();
      provider = AppStateProvider(storage);
    });

    Widget createAuthApp({Locale locale = const Locale('en')}) {
      return ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
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
          home: const AuthScreen(),
        ),
      );
    }

    testWidgets('Renders Apple ID and Email entry on standard screen (390x844)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createAuthApp());
      await tester.pumpAndSettle();

      // Verify Brand, Apple button and form fields are present
      expect(find.text('GHARAR'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(3)); // Name, Email, Password
      expect(find.text('Sign in with Apple'), findsOneWidget);
    });

    testWidgets('Renders with zero overflow on smallest iPhone SE (320x568)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320 * 2, 568 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createAuthApp());
      await tester.pumpAndSettle();

      // Check no overflow errors
      expect(tester.takeException(), isNull);
      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.text('Sign in with Apple'), findsOneWidget);
    });

    testWidgets('Renders Turkish localized text correctly',
        (WidgetTester tester) async {
      provider.setLanguageCode('tr');

      await tester.pumpWidget(createAuthApp(locale: const Locale('tr')));
      await tester.pumpAndSettle();

      // Check Turkish text
      expect(find.text('Apple ile Giriş Yap'), findsOneWidget);
      expect(find.text('Giriş Yap'), findsOneWidget);
      expect(find.text('Yeni Hesap'), findsOneWidget);
    });

    testWidgets('Renders Arabic RTL layout correctly',
        (WidgetTester tester) async {
      provider.setLanguageCode('ar');

      await tester.pumpWidget(createAuthApp(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      // Check Arabic text
      expect(find.text('تسجيل الدخول باستخدام Apple'), findsOneWidget);
      expect(find.text('تسجيل الدخول'), findsOneWidget);
    });

    testWidgets('Tapping Apple ID button calls provider.signInWithApple()',
        (WidgetTester tester) async {
      await tester.pumpWidget(createAuthApp());
      await tester.pumpAndSettle();

      final appleBtn = find.text('Sign in with Apple');
      expect(appleBtn, findsOneWidget);

      await tester.tap(appleBtn);
      await tester.pumpAndSettle();

      expect(provider.isAuthenticated, isTrue);
      expect(provider.authProvider, equals('apple'));
    });
  });
}
