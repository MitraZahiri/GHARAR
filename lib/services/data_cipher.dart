import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

/// Thrown when stored data is tampered with or was encrypted with another key.
class DataCipherException implements Exception {
  final String message;
  const DataCipherException(this.message);

  @override
  String toString() => 'DataCipherException($message)';
}

/// AES-256-GCM encryption for personal data kept on the device.
///
/// The key is random per install and lives in the platform key store
/// (Android Keystore, iOS Keychain), never next to the data it protects.
/// Stored values look like `enc1:<base64(nonce | ciphertext | tag)>`.
class DataCipher {
  static const prefix = 'enc1:';
  static const storageKey = 'gharar_data_key_v1';
  static const _nonceLength = 12;
  static const _tagBits = 128;

  final Uint8List _key;
  final Random _random = Random.secure();

  DataCipher(Uint8List key) : _key = Uint8List.fromList(key) {
    if (key.length != 32) {
      throw ArgumentError.value(key.length, 'key', 'must be 32 bytes');
    }
  }

  /// Loads this install's key from [storage], creating it on first use.
  static Future<DataCipher> fromSecureStorage(
    FlutterSecureStorage storage,
  ) async {
    final existing = await storage.read(key: storageKey);
    if (existing != null) return DataCipher(base64.decode(existing));
    final random = Random.secure();
    final key = Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );
    await storage.write(key: storageKey, value: base64.encode(key));
    return DataCipher(key);
  }

  static bool isEncrypted(String value) => value.startsWith(prefix);

  String encrypt(String plainText) {
    final nonce = Uint8List.fromList(
      List.generate(_nonceLength, (_) => _random.nextInt(256)),
    );
    final sealed = _gcm(true, nonce).process(utf8.encode(plainText));
    return prefix + base64.encode([...nonce, ...sealed]);
  }

  String decrypt(String stored) {
    if (!isEncrypted(stored)) {
      throw const DataCipherException('not encrypted');
    }
    try {
      final bytes = base64.decode(stored.substring(prefix.length));
      final nonce = bytes.sublist(0, _nonceLength);
      final opened = _gcm(false, nonce).process(bytes.sublist(_nonceLength));
      return utf8.decode(opened);
    } on InvalidCipherTextException {
      throw const DataCipherException('authentication failed');
    } on FormatException {
      throw const DataCipherException('malformed');
    } on RangeError {
      throw const DataCipherException('truncated');
    }
  }

  GCMBlockCipher _gcm(bool forEncryption, Uint8List nonce) =>
      GCMBlockCipher(AESEngine())..init(
        forEncryption,
        AEADParameters(KeyParameter(_key), _tagBits, nonce, Uint8List(0)),
      );
}
