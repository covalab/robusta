/// An exception presents for all exception cause by this extension.
class AuthException implements Exception {
  /// Throws in cases call logout but current credentials is null.
  factory AuthException.invalidLoggedState() => AuthException._(
        'Invalid logged state, can not do act!',
      );

  AuthException._(this._msg);

  final String _msg;

  @override
  String toString() => _msg;
}
