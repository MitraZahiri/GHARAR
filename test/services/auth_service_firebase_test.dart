import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gharar/services/auth_service.dart';

class _FakeAuthentication extends Fake implements GoogleSignInAuthentication {
  @override
  String? get idToken => 'id-token';
  @override
  String? get accessToken => 'access-token';
}

class _FakeAccount extends Fake implements GoogleSignInAccount {
  @override
  String get email => 'elif@gmail.com';
  @override
  String? get displayName => 'Elif';
  @override
  Future<GoogleSignInAuthentication> get authentication async =>
      _FakeAuthentication();
}

class _FakeGoogleSignIn extends Fake implements GoogleSignIn {
  _FakeGoogleSignIn({this.account, this.error});

  final GoogleSignInAccount? account;
  final Exception? error;
  bool signedOut = false;

  @override
  Future<GoogleSignInAccount?> signIn() async {
    if (error != null) throw error!;
    return account;
  }

  @override
  Future<bool> isSignedIn() async => true;

  @override
  Future<GoogleSignInAccount?> signOut() async {
    signedOut = true;
    return null;
  }
}

void main() {
  group('AuthService with Firebase', () {
    test(
      'Google sign-in creates a Firebase session and returns its uid',
      () async {
        final auth = MockFirebaseAuth(
          mockUser: MockUser(
            uid: 'uid_elif',
            email: 'elif@gmail.com',
            displayName: 'Elif',
          ),
        );
        final service = AuthService(
          googleSignIn: _FakeGoogleSignIn(account: _FakeAccount()),
          firebaseAuth: auth,
        );

        final result = await service.signInWithGoogle();

        expect(result.success, isTrue);
        expect(result.uid, 'uid_elif');
        expect(result.email, 'elif@gmail.com');
        expect(result.displayName, 'Elif');
        expect(auth.currentUser?.uid, 'uid_elif');
      },
    );

    test('closing the Google dialog is a cancellation', () async {
      final service = AuthService(
        googleSignIn: _FakeGoogleSignIn(),
        firebaseAuth: MockFirebaseAuth(),
      );

      final result = await service.signInWithGoogle();

      expect(result.isCancelled, isTrue);
      expect(result.success, isFalse);
    });

    test('a platform error is a failure, not a fake signed-in user', () async {
      final service = AuthService(
        googleSignIn: _FakeGoogleSignIn(
          error: PlatformException(code: 'sign_in_failed'),
        ),
        firebaseAuth: MockFirebaseAuth(),
      );

      final result = await service.signInWithGoogle();

      expect(result.success, isFalse);
      expect(result.errorMessage, contains('sign_in_failed'));
    });

    test('signOut ends both the Google and the Firebase session', () async {
      final google = _FakeGoogleSignIn(account: _FakeAccount());
      final auth = MockFirebaseAuth(signedIn: true);
      final service = AuthService(googleSignIn: google, firebaseAuth: auth);

      await service.signOut();

      expect(google.signedOut, isTrue);
      expect(auth.currentUser, isNull);
    });
  });
}
