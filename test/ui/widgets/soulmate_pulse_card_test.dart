import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/ui/widgets/soulmate_pulse_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SoulmatePulseCard Widget Tests', () {
    late StorageService storage;
    late AppStateProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      provider = AppStateProvider(storage);

      provider.completeOnboarding(
        name: 'Kerem',
        avatar: '🕊️',
        relationshipStage: 'married',
        goals: const ['deep_talks'],
        languageCode: 'tr',
      );
      provider.setLanguageCode('tr');
      provider.linkPartner(partnerName: 'Elif', avatar: '🌸');
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<AppStateProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: SoulmatePulseCard()),
          ),
        ),
      );
    }

    testWidgets('Renders presence of both partners and section header', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('RUH HALİ & BAĞLANTI'), findsOneWidget);
      expect(find.text('Sen'), findsOneWidget);
      expect(find.text('Elif'), findsOneWidget);
      expect(find.text('Görünüm Değiştir'), findsOneWidget);
      expect(find.text('Dokunuş'), findsOneWidget);
    });

    testWidgets('Tapping perspective switcher toggles active partner', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(provider.activePartner.name, 'Kerem');

      final switchBtn = find.text('Görünüm Değiştir');
      await tester.tap(switchBtn);
      await tester.pumpAndSettle();

      expect(provider.activePartner.name, 'Elif');
      expect(find.text('Kerem'), findsOneWidget);
      expect(find.text('Sen'), findsOneWidget);
    });

    testWidgets('Tapping love pulse sends nudge and displays snackbar', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(provider.lastNudgeTime, isNull);

      final pulseBtn = find.text('💓');
      expect(pulseBtn, findsOneWidget);
      await tester.tap(pulseBtn);
      await tester.pump(); // Start snackbar animation

      expect(provider.lastNudgeTime, isNotNull);
      expect(provider.lastNudgeSenderId, provider.activePartner.id);

      // Settle snackbar
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.textContaining('Elif için sıcacık bir sevgi dokunuşu gönderildi!'),
        findsOneWidget,
      );
    });

    testWidgets('Opening mood picker and selecting mood updates state', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final moodTile = find.text('+ Ruh Hali');
      expect(moodTile, findsOneWidget);
      await tester.tap(moodTile);
      await tester.pumpAndSettle();

      expect(find.text('Bugün Kalbin Nasıl Hissediyor? ✨'), findsOneWidget);

      final romanticOption = find.text('Aşık & Romantik');
      expect(romanticOption, findsOneWidget);
      await tester.tap(romanticOption);
      await tester.pumpAndSettle();

      expect(provider.activePartnerMood, 'romantic');
    });

    testWidgets(
      'Partner view never renders the "You" placeholder as a sender name',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final unnamed = AppStateProvider(StorageService(prefs));
        unnamed.completeOnboarding(
          name: '',
          avatar: '🌸',
          relationshipStage: 'married',
          goals: const ['deep_talks'],
          languageCode: 'en',
        );
        unnamed.setLanguageCode('en');
        unnamed.linkPartner(partnerName: 'Elif', avatar: '🌿');
        unnamed.sendLoveNudge();
        unnamed.switchActivePartner();

        await tester.pumpWidget(
          ChangeNotifierProvider<AppStateProvider>.value(
            value: unnamed,
            child: const MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(child: SoulmatePulseCard()),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('You is thinking'), findsNothing);
        expect(
          find.textContaining('Your Soulmate is thinking of you right now!'),
          findsOneWidget,
        );
      },
    );
  });
}
