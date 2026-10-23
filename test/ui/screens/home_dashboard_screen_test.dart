import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/screens/home/home_dashboard_screen.dart';
import 'package:gharar/ui/widgets/distance_mode_card.dart';
import 'package:gharar/ui/widgets/love_note_card.dart';
import 'package:gharar/ui/widgets/soulmate_pulse_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    provider = AppStateProvider(StorageService(prefs));
    provider.completeOnboarding(
      name: 'Kerem',
      avatar: '🕊️',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'tr',
    );
    provider.setLanguageCode('tr');
    provider.linkPartner(partnerName: 'Elif', avatar: '🌸');
  });

  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider<AppStateProvider>.value(
        value: provider,
        child: const MaterialApp(home: HomeDashboardScreen()),
      ),
    );
    await tester.pump();
  }

  testWidgets('home shows only pulse, daily question and love note', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.byType(SoulmatePulseCard), findsOneWidget);
    expect(find.byType(LoveNoteCard), findsOneWidget);
    expect(find.byKey(const ValueKey('home-daily-question')), findsOneWidget);

    // Secondary content lives in the Explore tab, not on home.
    expect(find.byType(DistanceModeCard), findsNothing);
    expect(find.textContaining('HAFTALIK'), findsNothing);
    expect(find.textContaining('KIVILCIM'), findsNothing);
  });

  testWidgets('question comes before the love note', (tester) async {
    await pumpHome(tester);

    final questionTop =
        tester.getTopLeft(find.byKey(const ValueKey('home-daily-question'))).dy;
    final noteTop = tester.getTopLeft(find.byType(LoveNoteCard)).dy;
    expect(questionTop, lessThan(noteTop));
  });

  testWidgets('distance chip summarises long distance and opens the card', (
    tester,
  ) async {
    provider.setDistanceMode(DistanceMode.longDistance);
    provider.setNextMeetingDate(DateTime.now().add(const Duration(days: 12)));
    await pumpHome(tester);

    final chip = find.byKey(const ValueKey('home-distance-chip'));
    expect(chip, findsOneWidget);
    expect(
      find.descendant(of: chip, matching: find.textContaining('12 gün')),
      findsOneWidget,
    );

    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(find.byType(DistanceModeCard), findsOneWidget);
  });
}
