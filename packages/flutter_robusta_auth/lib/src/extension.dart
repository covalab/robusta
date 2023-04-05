import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/access.dart';
import 'package:flutter_robusta_auth/src/auth.dart';
import 'package:flutter_robusta_auth/src/provider.dart';
import 'package:flutter_robusta_auth/src/screen.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:meta/meta.dart';

part 'extension/screen.dart';

/// Factory of [CredentialsStorage].
typedef CredentialsStorageFactory = CredentialsStorage Function(
  ProviderContainer,
);

/// Define access based on ability and rule of it.
typedef DefineAccess = void Function(AccessDefinition);

/// Define screen access control.
typedef DefineScreenAccess = void Function(ScreenAccessDefinition);

/// {@template extension.flutter_auth}
/// An extension providing authn/authz features.
/// {@endtemplate}
@sealed
class FlutterAuthExtension implements DependenceExtension {
  /// {@macro extension.flutter_auth}
  FlutterAuthExtension({
    CredentialsStorageFactory? credentialsStorageFactory,
    required IdentityProvider identityProvider,
    DefineAccess? defineAccess,
    DefineScreenAccess? defineScreenAccess,
  })  : _credentialsStorageFactory =
            credentialsStorageFactory ?? ((_) => CredentialsMemoryStorage()),
        _identityProvider = identityProvider {
    if (null != defineAccess) {
      defineAccess(_accessManager);
    }

    if (null != defineScreenAccess) {
      defineScreenAccess(_screenAccessDefinition);
    }
  }

  final CredentialsStorageFactory _credentialsStorageFactory;

  final IdentityProvider _identityProvider;

  final AccessManager _accessManager = AccessManager();

  late final ScreenAccessDefinition _screenAccessDefinition =
      ScreenAccessDefinition._(_accessManager);

  @override
  List<Type> dependsOn() => [FlutterAppExtension];

  @override
  Future<void> load(Configurator configurator) async {
    for (final redirector in _screenAccessDefinition._redirectors) {
      configurator.routerSettings.redirectorFactories.add((_) => redirector);
    }

    configurator
      ..addBoot(_boot, priority: 8)
      ..addContainerOverride(_authManagerOverride())
      ..addContainerOverride(_userOverride())
      ..addContainerOverride(_accessDefinitionOverride())
      ..addContainerOverride(_accessControlOverride())
      ..routerSettings.redirectorFactories.add((_) => ScreenRedirector())
      ..routerSettings.refreshNotifierFactories.add((_) => _accessManager)
      ..routerSettings.refreshNotifierFactories.add(
            (container) => container.read(authManagerProvider),
          );
  }

  Future<void> _boot(ProviderContainer container) async {
    /// Refresh identity for restoring identity state,
    /// in cases credentials storage of auth manager is persistent storage.
    await container.read(userProvider).refreshIdentity();
  }

  Override _authManagerOverride() {
    return authManagerProvider.overrideWith((ref) {
      final auth = AuthManager(
        credentialsStorage: _credentialsStorageFactory(ref.container),
        eventManager: ref.read(eventManagerProvider),
      );

      ref.onDispose(() => auth.removeListener(ref.notifyListeners));

      auth.addListener(ref.notifyListeners);

      return auth;
    });
  }

  Override _userOverride() {
    return userProvider.overrideWith((ref) {
      final em = ref.read(eventManagerProvider);
      final user = User(
        accessControl: _accessManager,
        authManager: ref.read(authManagerProvider),
        eventManager: em,
        identityProvider: (credentials) => _identityProvider(
          credentials,
          ref.container,
        ),
      );

      Future<void> onAuthStateChanged(_) async => user.refreshIdentity();

      void onIdentityChanged(IdentityChangedEvent e) {
        /// Avoid notify change when logout,
        /// prevent concurrency processing refresh router
        /// and rebuild widgets.
        if (null != e.newIdentity) {
          ref.notifyListeners();
        }
      }

      ref.onDispose(
        () => em
          ..removeEventListener<IdentityChangedEvent>(onIdentityChanged)
          ..removeEventListener<LoggedInEvent>(onAuthStateChanged)
          ..removeEventListener<LoggedOutEvent>(onAuthStateChanged),
      );

      em
        ..addEventListener<IdentityChangedEvent>(onIdentityChanged)
        ..addEventListener<LoggedInEvent>(onAuthStateChanged)
        ..addEventListener<LoggedOutEvent>(onAuthStateChanged);

      return user;
    });
  }

  Override _accessDefinitionOverride() {
    return accessDefinitionProvider.overrideWithValue(_accessManager);
  }

  Override _accessControlOverride() {
    return accessControlProvider.overrideWithValue(_accessManager);
  }
}
