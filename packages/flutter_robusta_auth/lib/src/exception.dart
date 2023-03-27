/// An exception presents for all exception cause by this extension.
class AuthException implements Exception {
  /// Throws in cases call logout but current credentials is null.
  factory AuthException.logoutWithNullCredentials() => AuthException._(
        'Current credentials is null, can not logout!',
      );

  /// Throws in cases call login but current credentials is NOT null.
  factory AuthException.loginWithExistCredentials() => AuthException._(
        'You should logout before login with new credentials!',
      );

  AuthException._(this._msg);

  final String _msg;

  @override
  String toString() => _msg;
}
