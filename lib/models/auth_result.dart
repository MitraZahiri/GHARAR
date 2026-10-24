class AuthResult {
  final bool success;
  final String? uid; // Firebase Auth uid, when signed in through Firebase
  final String? email;
  final String? displayName;
  final String? idToken;
  final String? authProvider; // 'google', 'apple', 'guest', 'email'
  final String? errorMessage;
  final bool isCancelled;

  const AuthResult({
    required this.success,
    this.uid,
    this.email,
    this.displayName,
    this.idToken,
    this.authProvider,
    this.errorMessage,
    this.isCancelled = false,
  });

  factory AuthResult.success({
    required String? email,
    required String? displayName,
    String? idToken,
    required String authProvider,
    String? uid,
  }) {
    return AuthResult(
      success: true,
      uid: uid,
      email: email,
      displayName: displayName,
      idToken: idToken,
      authProvider: authProvider,
    );
  }

  factory AuthResult.cancelled({required String authProvider}) {
    return AuthResult(
      success: false,
      isCancelled: true,
      authProvider: authProvider,
    );
  }

  factory AuthResult.failure({
    required String errorMessage,
    required String authProvider,
  }) {
    return AuthResult(
      success: false,
      errorMessage: errorMessage,
      authProvider: authProvider,
    );
  }

  AuthResult copyWith({
    bool? success,
    String? uid,
    String? email,
    String? displayName,
    String? idToken,
    String? authProvider,
    String? errorMessage,
    bool? isCancelled,
  }) {
    return AuthResult(
      success: success ?? this.success,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      idToken: idToken ?? this.idToken,
      authProvider: authProvider ?? this.authProvider,
      errorMessage: errorMessage ?? this.errorMessage,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResult &&
        other.success == success &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.idToken == idToken &&
        other.authProvider == authProvider &&
        other.errorMessage == errorMessage &&
        other.isCancelled == isCancelled;
  }

  @override
  int get hashCode => Object.hash(
    success,
    uid,
    email,
    displayName,
    idToken,
    authProvider,
    errorMessage,
    isCancelled,
  );
}
