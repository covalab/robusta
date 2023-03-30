import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:meta/meta.dart';

/// {@template auth.login_event}
/// An event will be dispatch when user logged-in.
/// {@endtemplate}
@sealed
class LoggedInEvent extends Event {
  /// {@macro auth.login_event}
  LoggedInEvent(this.credentials);

  /// Credentials of identity used to logged-in.
  final Map<String, String> credentials;
}

/// {@template auth.logout_event}
/// An event will be dispatch when user logged-out.
/// {@endtemplate}
@sealed
class LoggedOutEvent extends Event {
  /// {@macro auth.logout_event}
  LoggedOutEvent(this.oldCredentials);

  /// Old credentials of identity had used to logged-in.
  final Map<String, String> oldCredentials;
}

/// {@template auth_manager}
/// Service support to login/logout and manage credentials of current user.
/// {@endtemplate}
@sealed
class AuthManager with ChangeNotifier implements LoggedInState {
  /// {@macro auth_manager}
  AuthManager({
    required CredentialsStorage credentialsStorage,
    required EventManager eventManager,
  })  : _credentialsStorage = credentialsStorage,
        _eventManager = eventManager;

  final CredentialsStorage _credentialsStorage;

  final EventManager _eventManager;

  Future<void> loginByCrendentials(Map<String, String> credentials) async {
    if (null != currentCredentials) {
      throw AuthException.invalidLoggedState();
    }

    await _credentialsStorage.write(credentials);

    await _eventManager.dispatchEvent(LoggedInEvent(credentials));

    notifyListeners();
  }

  Future<void> logout() async {
    final credentials = currentCredentials;

    if (null == credentials) {
      throw AuthException.invalidLoggedState();
    }

    await _credentialsStorage.delete();

    await _eventManager.dispatchEvent(LoggedOutEvent(credentials));

    notifyListeners();
  }

  /// Current credentials of identity logged in to app.
  Map<String, String>? get currentCredentials => _credentialsStorage.read();

  @override
  bool get loggedIn => null != currentCredentials;
}

/// {@template credentials_storage}
/// Manage user credentials, credentials are JWT token,
/// basic auth token, refresh token, cookie
/// or something to identify current user with upstream.
/// {@endtemplate}
@internal
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
