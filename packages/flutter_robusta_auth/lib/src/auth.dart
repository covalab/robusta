import 'dart:async';

import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:go_router_plus/go_router_plus.dart';

part 'auth/events.dart';

abstract class Identity {
  @override
  String toString();
}

/// Providing identity by token given.
typedef IdentityProvider<T extends Identity> = T Function(String);

/// {@template auth}
/// Auth service of system.
/// {@endtemplate}
class Auth implements LoggedInState {
  /// {@macro auth}
  Auth({
    IdentityStorage? identityStorage,
    EventManager? eventManager,
  })  : _identityStorage = identityStorage,
        _eventManager = eventManager;

  final IdentityStorage? _identityStorage;

  final EventManager? _eventManager;

  Identity? _currentIdentity;

  Identity? get currentIdentity => _currentIdentity;

  @override
  bool get loggedIn =>
      null != currentIdentity || null != _identityStorage?.read();

  Future<void> login(Identity identity) async {
    _currentIdentity = identity;
    await _identityStorage?.write(identity);
    await _eventManager?.dispatchEvent(LoginEvent(identity));
  }

  Future<void> logout() async {
    if (null == _currentIdentity) {
      throw FlutterAuthException.logoutWithNullIdentity();
    }

    await _identityStorage?.purge();
    await _eventManager?.dispatchEvent(LogoutEvent(_currentIdentity!));

    _currentIdentity = null;
  }
}

class IdentityStorage<I extends Identity> {
  IdentityStorage({
    required Box<I> identityBox,
  }) : _identityBox = identityBox;

  final Box<I> _identityBox;

  FutureOr<void> write(I identity) => _identityBox.put(0, identity);

  I? read() => _identityBox.getAt(0);

  Future<void> purge() => _identityBox.deleteAt(0);
}
