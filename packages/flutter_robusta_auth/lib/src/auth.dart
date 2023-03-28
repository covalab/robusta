import 'dart:async';

import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';

class _AuthEvent extends Event {
  _AuthEvent(this.currentUser);

  final User currentUser;
}

/// {@template auth.login_event}
/// An event will be dispatch when user logged-in.
/// {@endtemplate}
class LoginEvent extends _AuthEvent {
  /// {@macro auth.login_event}
  LoginEvent(super.currentUser);
}

/// {@template auth.logout_event}
/// An event will be dispatch when user logged-out.
/// {@endtemplate}
class LogoutEvent extends _AuthEvent {
  /// {@macro auth.logout_event}
  LogoutEvent(super.currentUser);
}

typedef AuthUserProvider = User Function(Map<String, String>);

/// {@template auth_manager}
/// Service support to login/logout and manage credentials of current user.
/// {@endtemplate}
class AuthManager {
  /// {@macro auth_manager}
  AuthManager({
    required CredentialsStorage credentialsStorage,
    required this.userProvider,
    required EventManager eventManager,
  })  : _credentialsStorage = credentialsStorage,
        _eventManager = eventManager;

  final CredentialsStorage _credentialsStorage;

  final FutureOr<User> Function(Map<String, String>) userProvider;

  final EventManager _eventManager;

  Future<void> loginByCrendentials(Map<String, String> credentials) async {
    if (null != _credentialsStorage.read()) {
      throw AuthException.loginWithExistCredentials();
    }

    await _credentialsStorage.write(credentials);
    await _eventManager.dispatchEvent(
      LoginEvent(
        await userProvider(credentials),
      ),
    );
  }

  Future<void> logout() async {
    final credentials = _credentialsStorage.read();

    if (null == credentials) {
      throw AuthException.logoutWithNullCredentials();
    }

    await _eventManager.dispatchEvent(
      LogoutEvent(
        await userProvider(credentials),
      ),
    );

    await _credentialsStorage.delete();
  }
}

/// {@template credentials_storage}
/// Manage user credentials, credentials are JWT token,
/// basic auth token, refresh token, cookie
/// or something to identify current user with upstream.
/// {@endtemplate}
class CredentialsStorage {
  /// {@macro credentials_storage}
  CredentialsStorage({
    Box<String>? box,
  }) : _box = box;

  final Box<String>? _box;

  Map<String, String>? _credentials;

  /// Write credentials, store in memory buffer and put to disk if
  /// user want to persist.
  Future<void> write(Map<String, String> credentials) async {
    _credentials = credentials;

    for (final entry in credentials.entries) {
      await _box?.put(entry.key, entry.value);
    }
  }

  /// Remove credentials.
  Future<void> delete() async {
    _credentials = null;
    await _box?.clear();
  }

  /// Read credentials.
  Map<String, String>? read() {
    if (null != _credentials) {
      return _credentials;
    }

    if (null == _box || _box!.isEmpty) {
      return null;
    }

    final credentials = <String, String>{};

    for (final key in _box!.keys) {
      credentials[key.toString()] = _box!.get(key)!;
    }

    return _credentials = credentials;
  }
}
