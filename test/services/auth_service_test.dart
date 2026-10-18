import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/auth_result.dart';
import 'package:gharar/services/auth_service.dart';

void main() {
  group('AuthResult Model Tests', () {
    test('AuthResult.success creates valid success result', () {
      final result = AuthResult.success(
        email: 'test@example.com',
        displayName: 'Test User',
        idToken: 'token123',
        authProvider: 'google',
      );

      expect(result.success, isTrue);
      expect(result.isCancelled, isFalse);
      expect(result.email, equals('test@example.com'));
      expect(result.displayName, equals('Test User'));
      expect(result.idToken, equals('token123'));
      expect(result.authProvider, equals('google'));
      expect(result.errorMessage, isNull);
    });

    test('AuthResult.cancelled creates valid cancelled result', () {
      final result = AuthResult.cancelled(authProvider: 'apple');

      expect(result.success, isFalse);
      expect(result.isCancelled, isTrue);
      expect(result.email, isNull);
      expect(result.authProvider, equals('apple'));
      expect(result.errorMessage, isNull);
    });

    test(
      'AuthResult.failure creates valid failure result with error message',
      () {
        final result = AuthResult.failure(
          errorMessage: 'Network connection failed',
          authProvider: 'google',
        );

        expect(result.success, isFalse);
        expect(result.isCancelled, isFalse);
        expect(result.errorMessage, equals('Network connection failed'));
        expect(result.authProvider, equals('google'));
      },
    );
  });

  group('AuthService Tests', () {
    test(
      'signInWithGoogle handles successful authentication via override',
      () async {
        final authService = AuthService(
          googleSignInOverride:
              () async => AuthResult.success(
                email: 'user@gmail.com',
                displayName: 'Google User',
                authProvider: 'google',
              ),
        );

        final result = await authService.signInWithGoogle();

        expect(result.success, isTrue);
        expect(result.email, equals('user@gmail.com'));
        expect(result.displayName, equals('Google User'));
        expect(result.authProvider, equals('google'));
      },
    );

    test('signInWithGoogle handles user cancellation', () async {
      final authService = AuthService(
        googleSignInOverride:
            () async => AuthResult.cancelled(authProvider: 'google'),
      );

      final result = await authService.signInWithGoogle();

      expect(result.success, isFalse);
      expect(result.isCancelled, isTrue);
    });

    test('signInWithGoogle handles failure gracefully', () async {
      final authService = AuthService(
        googleSignInOverride:
            () async => AuthResult.failure(
              errorMessage: 'Missing Google Client ID configuration',
              authProvider: 'google',
            ),
      );

      final result = await authService.signInWithGoogle();

      expect(result.success, isFalse);
      expect(result.errorMessage, contains('Missing Google Client ID'));
    });

    test(
      'signInWithApple handles successful authentication via override',
      () async {
        final authService = AuthService(
          appleSignInOverride:
              () async => AuthResult.success(
                email: 'user@privaterelay.appleid.com',
                displayName: 'Apple User',
                authProvider: 'apple',
              ),
        );

        final result = await authService.signInWithApple();

        expect(result.success, isTrue);
        expect(result.email, equals('user@privaterelay.appleid.com'));
        expect(result.displayName, equals('Apple User'));
        expect(result.authProvider, equals('apple'));
      },
    );

    test('continueAsGuest returns valid guest result', () async {
      final authService = AuthService();

      final result = await authService.continueAsGuest();

      expect(result.success, isTrue);
      expect(result.authProvider, equals('guest'));
      expect(result.email, isNull);
    });
  });
}
