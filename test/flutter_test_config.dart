import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Runs before every test file: StorageService.init() reads its encryption
/// key from the platform key store, which tests replace with an in-memory one.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  FlutterSecureStorage.setMockInitialValues({});
  await testMain();
}
