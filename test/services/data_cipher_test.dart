import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/services/data_cipher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final key = Uint8List.fromList(List.generate(32, (i) => i));

  test('round-trips text, including non-Latin scripts', () {
    final cipher = DataCipher(key);
    const secret = 'Günlüğüm: seni seviyorum 💌 أحبك';

    final stored = cipher.encrypt(secret);

    expect(stored, isNot(contains('seviyorum')));
    expect(DataCipher.isEncrypted(stored), isTrue);
    expect(cipher.decrypt(stored), secret);
  });

  test('the same text encrypts differently each time (random nonce)', () {
    final cipher = DataCipher(key);
    expect(cipher.encrypt('same'), isNot(cipher.encrypt('same')));
  });

  test('tampered or foreign data is rejected', () {
    final cipher = DataCipher(key);
    final stored = cipher.encrypt('secret');
    final bytes = base64.decode(stored.substring(DataCipher.prefix.length));
    bytes[bytes.length - 1] ^= 1;
    final tampered = DataCipher.prefix + base64.encode(bytes);

    expect(() => cipher.decrypt(tampered), throwsA(isA<DataCipherException>()));
    final otherKey = DataCipher(Uint8List(32));
    expect(() => otherKey.decrypt(stored), throwsA(isA<DataCipherException>()));
  });

  test('legacy plain text is recognised as not encrypted', () {
    expect(DataCipher.isEncrypted('{"name":"Kerem"}'), isFalse);
  });

  test('rejects keys that are not 256-bit', () {
    expect(() => DataCipher(Uint8List(16)), throwsArgumentError);
  });

  group('fromSecureStorage', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('creates a key once and reuses it afterwards', () async {
      const storage = FlutterSecureStorage();
      final first = await DataCipher.fromSecureStorage(storage);
      final stored = first.encrypt('hello');

      final second = await DataCipher.fromSecureStorage(storage);

      expect(second.decrypt(stored), 'hello');
      expect(await storage.read(key: DataCipher.storageKey), isNotNull);
    });
  });
}
