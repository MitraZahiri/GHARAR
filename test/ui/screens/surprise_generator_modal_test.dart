import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/screens/activities/surprise_generator_modal.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    provider = AppStateProvider(StorageService(prefs));
  });

  Future<void> pumpModal(WidgetTester tester, String languageCode) async {
    provider.setLanguageCode(languageCode);
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider<AppStateProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: Scaffold(body: SurpriseGeneratorModal()),
        ),
      ),
    );
    await tester.pump();
  }

  String ideaText(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const ValueKey('surprise-idea'))).data!;

  testWidgets('speaks the chosen language, not only Turkish or English', (
    tester,
  ) async {
    await pumpModal(tester, 'de');

    expect(find.text('Romantischer Überraschungsgenerator'), findsOneWidget);
    expect(find.text('Romantic Surprise Generator'), findsNothing);

    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('rolling again always shows a different idea', (tester) async {
    await pumpModal(tester, 'en');

    var previous = ideaText(tester);
    for (var i = 0; i < 10; i++) {
      await tester.tap(find.text('Roll Another Surprise 🎲'));
      await tester.pump();
      final current = ideaText(tester);
      expect(current, isNot(previous));
      previous = current;
    }

    await tester.pump(const Duration(seconds: 3));
  });
}
