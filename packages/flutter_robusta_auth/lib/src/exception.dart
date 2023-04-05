/// Auth exception
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

/// Access exception
class AccessException implements Exception {
  /// An exception throws in case check policy with wrong arg type.
  factory AccessException.invalidRuleArgType(Type type, String ability) =>
      AccessException._(
        'Invalid rule args type of $ability ability, expect type is $type.',
      );

  /// An exception throws in case current identity not have permission to
  /// access app features.
  factory AccessException.deny() => AccessException._('Access denied!');

  AccessException._(this._msg);

  final String _msg;

  @override
  String toString() => _msg;
}
