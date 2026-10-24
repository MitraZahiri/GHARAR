import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/core/theme/app_theme.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/cloud_sync_service.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/screens/onboarding/onboarding_screen.dart';
import 'package:gharar/ui/screens/onboarding/partner_invite_screen.dart';

Widget _buildOnboardingTestApp(
  AppStateProvider provider, {
  bool isDark = false,
}) {
  return ChangeNotifierProvider<AppStateProvider>.value(
    value: provider,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const OnboardingScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();
    provider = AppStateProvider(storageService);
    provider.setLanguageCode('tr');
  });

  group('OnboardingScreen Modern Flow & Navigation Tests', () {
    testWidgets(
      'Renders top bar with GHARAR, language switcher and progress dashes',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildOnboardingTestApp(provider));
        await tester.pumpAndSettle();

        expect(find.text('GHARAR'), findsWidgets);
        expect(find.byType(OnboardingScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Stepping through onboarding slides navigates to PartnerInviteScreen',
      (WidgetTester tester) async {
        await tester.pumpWidget(_buildOnboardingTestApp(provider));
        await tester.pumpAndSettle();

        // Step 1: Welcome slide
        final continueButton = find.textContaining('Devam');
        expect(continueButton, findsOneWidget);
        await tester.tap(continueButton);
        await tester.pumpAndSettle();

        // Step 2: Profile slide (enter name)
        expect(find.textContaining('Kendinizi Tanıtın'), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, 'Leyla');
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('Devam'));
        await tester.pumpAndSettle();

        // Step 3: Relationship stage slide
        expect(find.textContaining('İlişkiniz Hangi Evrede?'), findsOneWidget);
        await tester.tap(find.textContaining('Devam'));
        await tester.pumpAndSettle();

        // Step 4: Goals slide
        expect(
          find.textContaining('Birlikte Neyi Büyütmek İstersiniz?'),
          findsOneWidget,
        );
        final invitePartnerButton = find.textContaining('Partnerimi Davet Et');
        expect(invitePartnerButton, findsOneWidget);

        await tester.tap(invitePartnerButton);
        await tester.pumpAndSettle();

        // Should navigate to PartnerInviteScreen
        expect(find.byType(PartnerInviteScreen), findsOneWidget);
        expect(provider.hasOnboarded, isTrue);
        expect(provider.currentUser?.name, equals('Leyla'));
      },
    );
  });

  group('PartnerInviteScreen Interactive Tests', () {
    testWidgets('Renders couple code, QR code and handles partner linking', (
      WidgetTester tester,
    ) async {
      provider.completeOnboarding(
        name: 'Kerem',
        avatar: '🕊️',
        relationshipStage: 'stageMarried',
        goals: ['goalDeeperConversations'],
        languageCode: 'tr',
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateProvider>.value(
          value: provider,
          child: const MaterialApp(home: PartnerInviteScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PartnerInviteScreen), findsOneWidget);
      expect(find.text('SİZE ÖZEL ÇİFT KODU'), findsOneWidget);
      expect(find.text('Kodu Kopyala'), findsOneWidget);
      expect(find.textContaining('QR Kodu Okutun'), findsOneWidget);
    });

    Future<void> enterCodeAndConnect(WidgetTester tester, String code) async {
      await tester.tap(find.textContaining('Partnerimin Kodu'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), code);
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Bağlan & Odayı Aç'));
      await tester.pumpAndSettle();
    }

    testWidgets('Without Google sign-in a code asks the user to sign in', (
      WidgetTester tester,
    ) async {
      provider.completeOnboarding(
        name: 'Kerem',
        avatar: '🕊️',
        relationshipStage: 'stageMarried',
        goals: ['goalDeeperConversations'],
        languageCode: 'tr',
      );
      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateProvider>.value(
          value: provider,
          child: const MaterialApp(home: PartnerInviteScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // The own code tab explains that sharing needs a sign-in.
      expect(
        find.text(
          'Google ile giriş yaptığında partnerin bu kodu kullanabilir.',
        ),
        findsOneWidget,
      );

      await enterCodeAndConnect(tester, 'GHARAR-5555-SOUL');

      expect(provider.isPartnerLinked, isFalse);
      expect(
        find.text('Partnerinle bağlanmak için Google ile giriş yap.'),
        findsOneWidget,
      );
    });

    testWidgets('Entering the partner code joins their couple', (
      WidgetTester tester,
    ) async {
      final db = FakeFirebaseFirestore();
      CloudSyncService cloudFor(String uid) => CloudSyncService(
        firestore: db,
        auth: MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: uid)),
      );
      final kerem = AppStateProvider(
        StorageService(await SharedPreferences.getInstance()),
        cloudSync: cloudFor('uid_kerem'),
      );
      addTearDown(kerem.dispose);
      kerem.completeOnboarding(
        name: 'Kerem',
        avatar: '🕊️',
        relationshipStage: 'stageMarried',
        goals: const [],
        languageCode: 'tr',
      );
      final elif = AppStateProvider(
        StorageService(await SharedPreferences.getInstance()),
        cloudSync: cloudFor('uid_elif'),
      );
      addTearDown(elif.dispose);
      elif.setLanguageCode('tr');
      elif.completeOnboarding(
        name: 'Elif',
        avatar: '🌸',
        relationshipStage: 'stageMarried',
        goals: const [],
        languageCode: 'tr',
      );
      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateProvider>.value(
          value: elif,
          child: const MaterialApp(home: PartnerInviteScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await enterCodeAndConnect(tester, 'GHARAR-ZZZZZZ');
      expect(
        find.text('Bu kod hiçbir çifte ait değil. Kontrol edip tekrar dene.'),
        findsOneWidget,
      );
      expect(elif.isPartnerLinked, isFalse);
      // Let the error message slide away before trying again.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), kerem.couple!.inviteCode);
      await tester.tap(find.textContaining('Bağlan & Odayı Aç'));
      await tester.pumpAndSettle();

      expect(elif.isPartnerLinked, isTrue);
      expect(elif.couple?.id, kerem.couple?.id);
      expect(elif.otherPartnerName, 'Kerem');
    });

    testWidgets('Simulating partner connection immediately links couple', (
      WidgetTester tester,
    ) async {
      provider.completeOnboarding(
        name: 'Kerem',
        avatar: '🕊️',
        relationshipStage: 'stageMarried',
        goals: ['goalDeeperConversations'],
        languageCode: 'tr',
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateProvider>.value(
          value: provider,
          child: const MaterialApp(home: PartnerInviteScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final simulateButton = find.textContaining(
        'Partnerin Girişini Simüle Et',
      );
      expect(simulateButton, findsOneWidget);
      await tester.ensureVisible(simulateButton);
      await tester.tap(simulateButton);
      await tester.pumpAndSettle();

      expect(provider.isPartnerLinked, isTrue);
    });
  });
}
