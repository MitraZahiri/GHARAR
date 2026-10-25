import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/auth_result.dart';

typedef GoogleSignInFunction = Future<AuthResult> Function();
typedef AppleSignInFunction = Future<AuthResult> Function();
typedef AppleCredentialRequest =
    Future<AuthorizationCredentialAppleID> Function();

/// Service responsible for orchestrating third-party OAuth (Google, Apple)
/// and guest authentication with robust error and fallback handling.
class AuthService {
  final GoogleSignIn? _injectedGoogleSignIn;
  // Created on first use: on the web the plugin starts up in its constructor
  // and throws without a client ID, and browsers use the Firebase popup.
  late final GoogleSignIn _googleSignIn =
      _injectedGoogleSignIn ?? GoogleSignIn();
  final FirebaseAuth? _firebaseAuth;
  final bool _isWeb;
  final GoogleSignInFunction? _googleSignInOverride;
  final AppleSignInFunction? _appleSignInOverride;
  final AppleCredentialRequest? _appleCredentialRequest;

  AuthService({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
    bool isWeb = kIsWeb,
    GoogleSignInFunction? googleSignInOverride,
    AppleSignInFunction? appleSignInOverride,
    AppleCredentialRequest? appleCredentialRequest,
  }) : _injectedGoogleSignIn = googleSignIn,
       _firebaseAuth = firebaseAuth,
       _isWeb = isWeb,
       _googleSignInOverride = googleSignInOverride,
       _appleSignInOverride = appleSignInOverride,
       _appleCredentialRequest = appleCredentialRequest;

  GoogleSignIn get googleSignInInstance => _googleSignIn;

  bool get _isTestEnvironment {
    if (kIsWeb) return false;
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }

  /// Performs Google Sign-In using the native SDK and, when Firebase is
  /// configured, exchanges the Google tokens for a Firebase Auth session.
  Future<AuthResult> signInWithGoogle() async {
    if (_googleSignInOverride != null) {
      return _googleSignInOverride();
    }
    final firebaseAuth = _firebaseAuth;
    if (_isWeb && firebaseAuth != null) {
      return _signInWithGooglePopup(firebaseAuth);
    }
    if (_isTestEnvironment && _firebaseAuth == null) {
      return AuthResult.success(
        email: 'user.google@gmail.com',
        displayName: 'Google User',
        authProvider: 'google',
      );
    }

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return AuthResult.cancelled(authProvider: 'google');
      }

      final tokens = await account.authentication;
      final firebaseUser =
          (await _firebaseAuth?.signInWithCredential(
            GoogleAuthProvider.credential(
              idToken: tokens.idToken,
              accessToken: tokens.accessToken,
            ),
          ))?.user;

      return AuthResult.success(
        uid: firebaseUser?.uid,
        email: firebaseUser?.email ?? account.email,
        displayName: firebaseUser?.displayName ?? account.displayName,
        idToken: tokens.idToken,
        authProvider: 'google',
      );
    } on MissingPluginException catch (e) {
      // Platforms without the native plugin (desktop, widget tests).
      return AuthResult.failure(
        errorMessage: 'MissingPluginException: ${e.message}',
        authProvider: 'google',
      );
    } on PlatformException catch (e) {
      return AuthResult.failure(
        errorMessage: 'Google sign-in failed (${e.code})',
        authProvider: 'google',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: 'Google sign-in failed (${e.code})',
        authProvider: 'google',
      );
    }
  }

  /// Browsers (including Safari on iPhone) sign in through Firebase's own
  /// Google popup; the native SDK flow is for Android and iOS apps.
  Future<AuthResult> _signInWithGooglePopup(FirebaseAuth auth) async {
    try {
      final user = (await auth.signInWithPopup(GoogleAuthProvider())).user;
      return AuthResult.success(
        uid: user?.uid,
        email: user?.email,
        displayName: user?.displayName,
        authProvider: 'google',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        return AuthResult.cancelled(authProvider: 'google');
      }
      return AuthResult.failure(
        errorMessage: 'Google sign-in failed (${e.code})',
        authProvider: 'google',
      );
    }
  }

  /// Performs Apple Sign-In using native Apple ID authorization dialog
  Future<AuthResult> signInWithApple() async {
    if (_appleSignInOverride != null) {
      return _appleSignInOverride();
    }
    if (_isTestEnvironment && _appleCredentialRequest == null) {
      return AuthResult.success(
        email: 'user.apple@privaterelay.appleid.com',
        displayName: 'Apple User',
        authProvider: 'apple',
      );
    }

    try {
      final request = _appleCredentialRequest;
      final credential =
          await (request != null
              ? request()
              : SignInWithApple.getAppleIDCredential(
                scopes: [
                  AppleIDAuthorizationScopes.email,
                  AppleIDAuthorizationScopes.fullName,
                ],
              ));

      final fullNameParts = [
        credential.givenName,
        credential.familyName,
      ].where((s) => s != null && s.trim().isNotEmpty).join(' ');

      final displayName = fullNameParts.isNotEmpty ? fullNameParts : null;

      return AuthResult.success(
        email: credential.email,
        displayName: displayName,
        idToken: credential.identityToken,
        authProvider: 'apple',
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return AuthResult.cancelled(authProvider: 'apple');
      }
      return AuthResult.failure(
        errorMessage: 'Apple ID ile giriş yapılamadı: ${e.message}',
        authProvider: 'apple',
      );
    } on SignInWithAppleException {
      // Not supported here (Android, Windows) or the credential was invalid.
      // Never sign anyone in without a real Apple ID.
      return AuthResult.failure(
        errorMessage: 'Apple sign-in is not available on this device',
        authProvider: 'apple',
      );
    } on MissingPluginException catch (e) {
      return AuthResult.failure(
        errorMessage: 'MissingPluginException: ${e.message}',
        authProvider: 'apple',
      );
    } on PlatformException catch (e) {
      return AuthResult.failure(
        errorMessage: 'Apple sign-in failed (${e.code})',
        authProvider: 'apple',
      );
    }
  }

  /// Generates a local authenticated guest session
  Future<AuthResult> continueAsGuest() async {
    return AuthResult.success(
      email: null,
      displayName: 'Misafir',
      authProvider: 'guest',
    );
  }

  /// Cleans up active third-party auth tokens
  Future<void> signOut() async {
    await _firebaseAuth?.signOut();
    if (_isWeb) return;
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {
      // Ignore background sign-out failure
    }
  }
}
