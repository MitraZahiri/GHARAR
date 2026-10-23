import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppStateProvider> freshProvider([
    Map<String, Object> values = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(values);
    final prefs = await SharedPreferences.getInstance();
    return AppStateProvider(StorageService(prefs));
  }

  test('skipping names stores empty values, not placeholders', () async {
    final provider = await freshProvider();
    provider.completeOnboarding(
      name: '   ',
      avatar: '🌸',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'tr',
    );
    provider.linkPartner(partnerName: '');

    expect(provider.activePartner.name, '');
    expect(provider.otherPartner.name, '');
    expect(provider.coupleDisplayNames, 'You & Your Soulmate');
  });

  test('I am You; the partner shows the name from their own sign-in', () async {
    final provider = await freshProvider();
    provider.completeOnboarding(
      name: ' Kerem ',
      avatar: '🌸',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'en',
    );
    expect(provider.currentUser?.name, 'Kerem');
    expect(provider.coupleDisplayNames, 'You & Your Soulmate');

    // The partner joins with the name they entered at sign-in.
    provider.linkPartner(partnerName: 'Elif');
    expect(provider.coupleDisplayNames, 'You & Elif');
  });

  test('onboarding keeps the name from sign-in when left empty', () async {
    final provider = await freshProvider();
    await provider.authenticateWithEmail(
      name: 'Mitra',
      email: 'mitra@example.com',
      password: 'secret1',
    );
    provider.completeOnboarding(
      name: '',
      avatar: '🌸',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'en',
    );

    expect(provider.currentUser?.name, 'Mitra');
  });

  test('legacy placeholder names are cleaned when loading', () async {
    final seeded = await freshProvider();
    seeded.completeOnboarding(
      name: 'You',
      avatar: '🌸',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'en',
    );
    seeded.linkPartner(partnerName: 'My Soulmate');
    final prefs = await SharedPreferences.getInstance();
    final snapshot = {for (final k in prefs.getKeys()) k: prefs.get(k)!};
    // Simulate data written by an older build that stored placeholders.
    final couple =
        jsonDecode(snapshot['gharar_couple'] as String) as Map<String, dynamic>;
    (couple['partner1'] as Map<String, dynamic>)['name'] = 'You';
    (couple['partner2'] as Map<String, dynamic>)['name'] = 'My Soulmate';
    snapshot['gharar_couple'] = jsonEncode(couple);

    final provider = await freshProvider(snapshot);

    expect(provider.activePartner.name, '');
    expect(provider.otherPartner.name, '');
  });
}
