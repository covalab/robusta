import 'dart:async';

import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:go_router_plus/go_router_plus.dart';

class _AuthEvent extends Event {
  _AuthEvent(this.credentials);

  final Map<String, String> credentials;
}

class LoginEvent extends _AuthEvent {
  LoginEvent(super.credentials);
}

class LogoutEvent extends _AuthEvent {
  LogoutEvent(super.credentials);
}

/// {@template auth}
/// Service support to login/logout and manage credentials of current user.
/// Credentials are JWT token, Basic auth token, refresh token, cookie
/// or something to identify current user with your upstream.
/// {@endtemplate}
class Auth implements LoggedInState {
  /// {@macro auth}
  Auth({
    Box<String>? credentialsBox,
    EventManager? eventManager,
  })  : _credentialsBox = credentialsBox,
        _eventManager = eventManager;

  final Box<String>? _credentialsBox;

  final EventManager? _eventManager;

  Map<String, String>? _currentCredentials;

  @override
  bool get loggedIn => null != currentCredentials;

  Future<void> login(Map<String, String> credentials) async {
    if (null != currentCredentials) {
      throw AuthException.loginWithExistCredentials();
    }

    for (final entry in credentials.entries) {
      await _credentialsBox?.put(entry.key, entry.value);
    }

    await _eventManager?.dispatchEvent(LoginEvent(credentials));
  }

  Future<void> logout() async {
    final credentials = currentCredentials;

    if (null == credentials) {
      throw AuthException.logoutWithNullCredentials();
    }

    await _credentialsBox?.clear();

    _currentCredentials = null;

    await _eventManager?.dispatchEvent(LogoutEvent(credentials));
  }

  Map<String, String>? get currentCredentials {
    if (null != _currentCredentials) {
      return _currentCredentials;
    }

    if (null == _credentialsBox || _credentialsBox!.isEmpty) {
      return null;
    }

    final credentials = <String, String>{};

    for (final key in _credentialsBox!.keys) {
      credentials[key.toString()] = _credentialsBox!.get(key)!;
    }

    return _currentCredentials = credentials;
  }
}
