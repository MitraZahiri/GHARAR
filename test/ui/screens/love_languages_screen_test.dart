import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/love_language.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/screens/discover/love_languages_screen.dart';

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
      languageCode: 'en',
    );
    provider.linkPartner(partnerName: 'Elif', avatar: '🌸');
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider<AppStateProvider>.value(
        value: provider,
        child: const MaterialApp(home: LoveLanguagesScreen()),
      ),
    );
    await tester.pump();
  }

  testWidgets('answering every question saves and shows my love language', (
    tester,
  ) async {
    await pumpScreen(tester);

    // Always pick the first statement of each pair.
    for (var i = 0; i < LoveLanguageQuiz.questions.length; i++) {
      await tester.tap(find.byKey(const ValueKey('love-language-option-0')));
      await tester.pumpAndSettle();
    }

    final expected = LoveLanguageQuiz.primaryFrom([
      for (final q in LoveLanguageQuiz.questions) q.first.language,
    ]);
    expect(provider.activePartnerLoveLanguage, expected);
    expect(find.byKey(const ValueKey('love-language-result')), findsOneWidget);
    expect(find.text(expected!.title(false)), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows both results and a tip when both partners took it', (
    tester,
  ) async {
    provider.setMyLoveLanguage(LoveLanguage.touch);
    provider.switchActivePartner();
    provider.setMyLoveLanguage(LoveLanguage.service);
    provider.switchActivePartner();

    await pumpScreen(tester);

    expect(find.text(LoveLanguage.touch.title(false)), findsWidgets);
    expect(find.text(LoveLanguage.service.title(false)), findsWidgets);
    expect(find.text(LoveLanguage.service.partnerTip(false)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('retake starts the quiz again', (tester) async {
    provider.setMyLoveLanguage(LoveLanguage.gifts);
    await pumpScreen(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('love-language-retake')),
    );
    await tester.tap(find.byKey(const ValueKey('love-language-retake')));
    await tester.pumpAndSettle();

    expect(provider.activePartnerLoveLanguage, isNull);
    expect(
      find.byKey(const ValueKey('love-language-option-0')),
      findsOneWidget,
    );
  });
}
