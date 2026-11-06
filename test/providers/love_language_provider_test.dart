import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/love_language.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      goals: const [],
      languageCode: 'en',
    );
    provider.linkPartner(partnerName: 'Elif', avatar: '🌸');
  });

  test('starts with no love language for either partner', () {
    expect(provider.activePartnerLoveLanguage, isNull);
    expect(provider.otherPartnerLoveLanguage, isNull);
  });

  test('saves the result for the partner who took the quiz', () {
    provider.setMyLoveLanguage(LoveLanguage.time);

    expect(provider.activePartnerLoveLanguage, LoveLanguage.time);
    expect(provider.otherPartnerLoveLanguage, isNull);

    provider.switchActivePartner();
    expect(provider.activePartnerLoveLanguage, isNull);
    expect(provider.otherPartnerLoveLanguage, LoveLanguage.time);

    provider.setMyLoveLanguage(LoveLanguage.touch);
    expect(provider.activePartnerLoveLanguage, LoveLanguage.touch);
    expect(provider.otherPartnerLoveLanguage, LoveLanguage.time);
  });

  test('result survives an app restart', () async {
    provider.setMyLoveLanguage(LoveLanguage.words);
    await Future<void>.delayed(Duration.zero);

    final reloaded = AppStateProvider(storage);
    await Future<void>.delayed(Duration.zero);

    expect(reloaded.activePartnerLoveLanguage, LoveLanguage.words);
  });

  test('retaking the quiz clears my result only', () {
    provider.setMyLoveLanguage(LoveLanguage.gifts);
    provider.switchActivePartner();
    provider.setMyLoveLanguage(LoveLanguage.service);

    provider.clearMyLoveLanguage();

    expect(provider.activePartnerLoveLanguage, isNull);
    expect(provider.otherPartnerLoveLanguage, LoveLanguage.gifts);
  });
}
