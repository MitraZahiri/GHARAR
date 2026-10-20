import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/ui/widgets/love_note_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoveNoteCard Widget Tests', () {
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
          home: Scaffold(body: SingleChildScrollView(child: LoveNoteCard())),
        ),
      );
    }

    testWidgets(
      'Renders empty state when no notes exist and triggers simulation',
      (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('SEVGİ NOTU TAHTASI'), findsOneWidget);
        expect(
          find.textContaining('Elif’in Ana Sayfasına Bir Not Bırak'),
          findsOneWidget,
        );
        expect(find.text('Sevgi Notu İliştir ✍️'), findsOneWidget);

        final simulateBtn = find.text('Partnerden Not Simüle Et (Test)');
        expect(simulateBtn, findsOneWidget);
        await tester.tap(simulateBtn);
        await tester.pumpAndSettle();

        // Now an unopened wax-seal letter from Elif appears!
        expect(
          find.textContaining('Elif Sana Bir Sevgi Notu Bıraktı!'),
          findsOneWidget,
        );
        expect(find.textContaining('Mührü açmak için dokun'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping wax seal letter opens and reveals the post-it love note',
      (tester) async {
        // Simulate note from Elif first
        provider.simulatePartnerLoveNote(
          customMessage:
              'Telefonun kapalıyken bu notu bıraktım, seni çok seviyorum! 💖',
        );

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Elif Sana Bir Sevgi Notu Bıraktı!'),
          findsOneWidget,
        );

        // Tap wax seal to open
        final waxSealFinder = find.textContaining('Mührü açmak için dokun');
        await tester.tap(waxSealFinder);
        await tester.pumpAndSettle();

        // Note is now opened!
        expect(find.textContaining('Elif’den Not'), findsOneWidget);
        expect(
          find.textContaining('Telefonun kapalıyken bu notu bıraktım'),
          findsOneWidget,
        );
        expect(find.text('Cevap Notu Yaz ✍️'), findsOneWidget);
        expect(provider.latestNoteForActivePartner?.isRead, isTrue);
      },
    );
  });
}
