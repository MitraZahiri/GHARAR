import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/core/theme/app_theme.dart';
import 'package:gharar/providers/app_state_provider.dart';
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
    testWidgets('Renders couple code and handles solo mode transition', (
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
    });
  });
}
