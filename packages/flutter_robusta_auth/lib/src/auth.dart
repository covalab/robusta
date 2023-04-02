import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/exception.dart';
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

  /// Login app by credentials like JWT token, basic auth token, cookie based...
  Future<void> loginByCrendentials(Map<String, String> credentials) async {
    if (null != currentCredentials) {
      throw AuthException.invalidLoggedState();
    }

    await _credentialsStorage.write(credentials);

    await _eventManager.dispatchEvent(LoggedInEvent(credentials));

    notifyListeners();
  }

  /// Logout app.
  Future<void> logout() async {
    final credentials = await currentCredentials;

    if (null == credentials) {
      throw AuthException.invalidLoggedState();
    }

    await _credentialsStorage.delete();

    await _eventManager.dispatchEvent(LoggedOutEvent(credentials));

    notifyListeners();
  }

  /// Current credentials of identity logged in to app.
  FutureOr<Map<String, String>?> get currentCredentials =>
      _credentialsStorage.read();

  @override
  Future<bool> get loggedIn async => null != (await currentCredentials);
}

/// {@template credentials_storage}
/// Manage user credentials, credentials are JWT token,
/// basic auth token, refresh token, cookie
/// or something to identify current user with upstream.
/// {@endtemplate}
abstract class CredentialsStorage {
  /// Write credentials, store in memory buffer and put to disk if
  /// user want to persist.
  FutureOr<void> write(Map<String, String> credentials);

  /// Remove credentials.
  FutureOr<void> delete();

  /// Read credentials.
  FutureOr<Map<String, String>?> read();
}

/// Store credentials in memory, when app terminated all data will be lose.
class CredentialsMemoryStorage implements CredentialsStorage {
  Map<String, String>? _credentials;

  @override
  void delete() => _credentials = null;

  @override
  Map<String, String>? read() => _credentials;

  @override
  void write(Map<String, String> credentials) => _credentials = credentials;
}
