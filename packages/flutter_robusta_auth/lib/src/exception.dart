import 'package:flutter_robusta/flutter_robusta.dart';

/// An exception presents for all exception cause by this extension.
class FlutterAuthException implements Exception {
  /// Throws in cases not found app extension.
  factory FlutterAuthException.appExtensionNotFound() => FlutterAuthException._(
        '$MaterialExtension or $CupertinoExtension should be use',
      );

  /// Throws in cases call logout but current identity is null.
  factory FlutterAuthException.logoutWithNullIdentity() =>
      FlutterAuthException._(
        'Current user identity is null, can not logout!',
      );

  FlutterAuthException._(this._msg);

  final String _msg;

  @override
  String toString() => _msg;
}
