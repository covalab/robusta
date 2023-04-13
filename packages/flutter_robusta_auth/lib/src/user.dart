import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/access.dart';
import 'package:flutter_robusta_auth/src/auth.dart';
import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:meta/meta.dart';

/// {@template user.identity}
/// Present for identity using app
/// {@endtemplate}
@sealed
class Identity {
  /// {@macro user.identity}
  Identity({required this.id, required this.data});

  /// Unique identify.
  final String id;

  /// Identity data.
  final Map<String, dynamic> data;

  late final AccessControl _accessControl;

  /// Verify identity has [ability] with [arg].
  FutureOr<bool> allows<Arg>(String ability, [Arg? arg]) =>
      _accessControl.check<Arg>(
        this,
        ability,
        arg,
      );

  /// Like [allows] but throws [AccessException.deny].
  Future<void> authorize<Arg>(String ability, [Arg? arg]) =>
      _accessControl.authorize<Arg>(this, ability, arg);
}

/// Providing user by credentials and container given,
/// exceptions MUST be throws in cases invalid credentials
/// or something went wrong can't provide user.
typedef IdentityProvider = FutureOr<Identity> Function(
  Map<String, String>,
  ProviderContainer,
);

/// Providing user by credentials given, exceptions MUST be throws in cases
/// invalid credentials or something went wrong can't provide user.
typedef SimpleIdentityProvider = FutureOr<Identity> Function(
  Map<String, String>,
);

/// {@template user.identity_changed_event}
/// An event dispatch in cases [User.currentIdentity] changed.
/// {@endtemplate}
@sealed
class IdentityChangedEvent extends Event {
  /// {@macro user.identity_changed_event}
  IdentityChangedEvent(this.oldIdentity, this.newIdentity);

  /// Old identity before refresh
  final Identity? oldIdentity;

  /// New identity refreshed.
  final Identity? newIdentity;
}

/// {@template user.user}
/// Manages current identity using apps.
/// {@endtemplate}
@sealed
class User {
  /// {@macro user.user}
  User({
    required SimpleIdentityProvider identityProvider,
    required AuthManager authManager,
    required EventManager eventManager,
    required AccessControl accessControl,
  })  : _identityProvider = identityProvider,
        _authManager = authManager,
        _eventManager = eventManager,
        _accessControl = accessControl;

  final SimpleIdentityProvider _identityProvider;

  final AuthManager _authManager;

  final EventManager _eventManager;

  final AccessControl _accessControl;

  Identity? _identity;

  /// Current identity logged-in to app.
  Identity? get currentIdentity => _identity;

  /// Refresh current identity.
  Future<void> refreshIdentity() async {
    final oldIdentity = _identity;
    final credentials = await _authManager.currentCredentials;

    if (null != credentials) {
      _identity = await _identityProvider(credentials);
      _identity!._accessControl = _accessControl;
    } else {
      _identity = null;
    }

    if (oldIdentity != _identity) {
      await _eventManager.dispatchEvent<IdentityChangedEvent>(
        IdentityChangedEvent(oldIdentity, _identity),
      );
    }
  }
}
