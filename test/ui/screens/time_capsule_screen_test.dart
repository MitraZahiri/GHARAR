import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/screens/memories/time_capsule_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late AppStateProvider provider;

  setUp(() async {
    now = DateTime(2026, 10, 30, 12);
    SharedPreferences.setMockInitialValues({});
    provider = AppStateProvider(
      StorageService(await SharedPreferences.getInstance()),
      clock: () => now,
    );
    provider.completeOnboarding(
      name: 'Kerem',
      avatar: '🕊️',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'en',
    );
    provider.linkPartner(partnerName: 'Elif', avatar: '🌸');
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider<AppStateProvider>.value(
        value: provider,
        child: const MaterialApp(home: TimeCapsuleScreen()),
      ),
    );
    await tester.pump();
  }

  testWidgets('writing and sealing a capsule for six months', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(
      find.byKey(const ValueKey('time-capsule-text')),
      'Remember this autumn?',
    );
    await tester.tap(find.byKey(const ValueKey('time-capsule-delay-180')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('time-capsule-seal')));
    await tester.pumpAndSettle();

    final sent = provider.timeCapsulesSentByActivePartner.single;
    expect(sent.text, 'Remember this autumn?');
    expect(sent.opensAt, now.add(const Duration(days: 180)));
    expect(find.text('Remember this autumn?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a received capsule hides its words until it opens', (
    tester,
  ) async {
    provider.switchActivePartner();
    provider.sendTimeCapsule(
      text: 'A secret for later',
      opensAt: now.add(const Duration(days: 30)),
    );
    provider.switchActivePartner();

    await pumpScreen(tester);
    expect(find.text('A secret for later'), findsNothing);
    expect(find.textContaining('30 days'), findsOneWidget);

    now = now.add(const Duration(days: 30));
    await tester.pumpWidget(const SizedBox());
    await pumpScreen(tester);
    expect(find.text('A secret for later'), findsOneWidget);
  });
}
