import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/journal_entry_model.dart';
import 'package:gharar/models/love_note_model.dart';
import 'package:gharar/models/user_model.dart';
import 'package:gharar/services/data_cipher.dart';
import 'package:gharar/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final cipher = DataCipher(Uint8List.fromList(List.generate(32, (i) => i)));
  final user = UserModel(
    id: 'uid_kerem',
    name: 'Kerem',
    avatar: '🕊️',
    preferredLanguage: 'tr',
    relationshipStage: 'married',
    selectedGoals: const [],
    joinedAt: DateTime(2026, 10, 1),
    email: 'kerem@example.com',
  );
  final note = LoveNoteModel(
    id: 'note_1',
    senderId: 'uid_kerem',
    senderName: 'Kerem',
    receiverId: 'uid_elif',
    text: 'Seni çok özledim',
    paperColor: 'rose',
    emoji: '💌',
    createdAt: DateTime(2026, 10, 24),
  );

  Future<(SharedPreferences, StorageService)> encryptedStorage([
    Map<String, Object> initial = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(Map.of(initial));
    final prefs = await SharedPreferences.getInstance();
    return (prefs, StorageService(prefs, cipher: cipher));
  }

  /// Everything SharedPreferences holds, as one string, to look for leaks.
  String rawDump(SharedPreferences prefs) =>
      prefs.getKeys().map((k) => '$k=${prefs.get(k)}').join('\n');

  test('sensitive data is never stored as plain text', () async {
    final (prefs, storage) = await encryptedStorage();

    await storage.saveUser(user);
    await storage.setUserEmail('kerem@example.com');
    await storage.saveLoveNotes([note]);
    await storage.saveJournal([
      JournalEntryModel(
        id: 'j1',
        title: 'Gizli günlük',
        notes: 'Çok özel',
        authorId: 'uid_kerem',
        authorName: 'Kerem',
        date: DateTime(2026, 10, 24),
        moodEmoji: '🙂',
      ),
    ]);
    await storage.savePartnerMoods({'uid_kerem': 'sad'});
    await storage.setLastNudgeMessage('Thinking of you');

    final dump = rawDump(prefs);
    for (final secret in [
      'Kerem',
      'kerem@example.com',
      'özledim',
      'Gizli günlük',
      'sad',
      'Thinking of you',
    ]) {
      expect(dump, isNot(contains(secret)), reason: secret);
    }

    expect(storage.getUser()?.name, 'Kerem');
    expect(storage.userEmail, 'kerem@example.com');
    expect(storage.getLoveNotes()?.single.text, 'Seni çok özledim');
    expect(storage.getJournal()?.single.title, 'Gizli günlük');
    expect(storage.getPartnerMoods(), {'uid_kerem': 'sad'});
    expect(storage.getLastNudgeMessage(), 'Thinking of you');
  });

  test(
    'plain text from older versions is still read and then encrypted',
    () async {
      final (prefs, storage) = await encryptedStorage({
        'gharar_user_email': 'old@example.com',
        'gharar_user':
            '{"id":"user_1","name":"Leyla","avatar":"🌸","preferredLanguage":"tr",'
            '"relationshipStage":"married","selectedGoals":[],'
            '"joinedAt":"2026-01-01T00:00:00.000"}',
      });

      expect(storage.getUser()?.name, 'Leyla');
      expect(storage.userEmail, 'old@example.com');

      await storage.encryptLegacyValues();

      expect(rawDump(prefs), isNot(contains('Leyla')));
      expect(rawDump(prefs), isNot(contains('old@example.com')));
      expect(storage.getUser()?.name, 'Leyla');
    },
  );

  test('data that cannot be decrypted reads as missing, not a crash', () async {
    final (prefs, storage) = await encryptedStorage();
    await storage.saveUser(user);

    // Same data, but the key is gone (e.g. a restored backup).
    final other = StorageService(prefs, cipher: DataCipher(Uint8List(32)));

    expect(other.getUser(), isNull);
    expect(other.userEmail, isNull);
  });

  test('settings that are not personal stay readable', () async {
    final (prefs, storage) = await encryptedStorage();
    await storage.setLocaleCode('tr');
    await storage.setHasOnboarded(true);

    expect(prefs.getString('gharar_locale'), 'tr');
    expect(prefs.getBool('gharar_has_onboarded'), isTrue);
  });

  test('init sets up encryption from the secure key store', () async {
    SharedPreferences.setMockInitialValues({'gharar_user_email': 'a@b.com'});
    FlutterSecureStorage.setMockInitialValues({});

    final storage = await StorageService.init();
    final prefs = await SharedPreferences.getInstance();

    expect(storage.userEmail, 'a@b.com');
    expect(prefs.getString('gharar_user_email'), isNot('a@b.com'));
  });
}
