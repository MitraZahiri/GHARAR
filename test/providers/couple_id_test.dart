import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('couples set up back to back never share an id', () async {
    final ids = <String>{};
    for (var i = 0; i < 20; i++) {
      SharedPreferences.setMockInitialValues({});
      final provider = AppStateProvider(
        StorageService(await SharedPreferences.getInstance()),
      );
      provider.completeOnboarding(
        name: 'Partner $i',
        avatar: '🌸',
        relationshipStage: 'married',
        goals: const [],
        languageCode: 'en',
      );
      ids.add(provider.couple!.id);
    }

    expect(ids.length, 20);
  });
}
