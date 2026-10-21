import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/widgets/distance_mode_card.dart';

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

  Widget createTestWidget() {
    return ChangeNotifierProvider<AppStateProvider>.value(
      value: provider,
      child: const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: DistanceModeCard())),
      ),
    );
  }

  testWidgets('together mode shows a ritual and cycles to another idea', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Yakın Mesafe'), findsOneWidget);
    expect(find.text('Uzak Mesafe'), findsOneWidget);
    expect(find.text('Aynı şehir, aynı gökyüzü'), findsOneWidget);

    final firstIdea = tester.widget<Text>(
      find.byKey(const ValueKey('together-ritual')),
    );
    await tester.tap(find.text('Başka fikir'));
    await tester.pump();
    final nextIdea = tester.widget<Text>(
      find.byKey(const ValueKey('together-ritual')),
    );
    expect(nextIdea.data, isNot(firstIdea.data));
  });

  testWidgets('switching to long distance shows clock and countdown', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Uzak Mesafe'));
    await tester.pump();

    expect(provider.distanceMode, DistanceMode.longDistance);
    expect(find.text('Saat dilimini ayarla'), findsOneWidget);
    expect(find.text('Buluşma tarihi seç'), findsOneWidget);

    provider.setPartnerUtcOffset(180);
    provider.setNextMeetingDate(DateTime.now().add(const Duration(days: 5)));
    await tester.pump();

    expect(find.text('UTC+3'), findsOneWidget);
    expect(find.textContaining('5 gün'), findsOneWidget);
  });

  testWidgets('long distance card fits a 320px wide phone', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    provider.setDistanceMode(DistanceMode.longDistance);
    provider.setPartnerUtcOffset(-570);

    await tester.pumpWidget(createTestWidget());

    expect(tester.takeException(), isNull);
    expect(find.text('UTC-9:30'), findsOneWidget);
  });
}
