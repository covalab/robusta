import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/auth.dart';
import 'package:meta/meta.dart';

/// Present for identity using app.
abstract class Identity {
  /// Unique id.
  String get id;

  /// Data related of identity.
  Map<String, dynamic> get data => {};
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

/// {@template user.identity_refresh_event}
/// An event dispatch in cases [User.refreshIdentity] called.
/// {@endtemplate}
@sealed
class IdentityRefreshEvent extends Event {
  /// {@macro user.identity_refresh_event}
  IdentityRefreshEvent(this.oldIdentity, this.newIdentity);

  /// Old identity before refresh
  final Identity? oldIdentity;

  /// New identity refreshed.
  final Identity newIdentity;
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
  })  : _identityProvider = identityProvider,
        _authManager = authManager,
        _eventManager = eventManager;

  final SimpleIdentityProvider _identityProvider;

  final AuthManager _authManager;

  final EventManager _eventManager;

  Identity? _identity;

  /// Current identity logged-in to app.
  Identity? get currentIdentity => _identity;

  /// Refresh current identity.
  Future<void> refreshIdentity() async {
    final oldIdentity = _identity;
    final credentials = _authManager.currentCredentials;

    _identity = null;

    if (null == credentials) {
      return;
    }

    _identity = await _identityProvider(credentials);

    await _eventManager.dispatchEvent<IdentityRefreshEvent>(
      IdentityRefreshEvent(oldIdentity, _identity!),
    );
  }
}
