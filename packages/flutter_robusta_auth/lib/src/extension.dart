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
typedef DefineScreenAccessControl = void Function(ScreenAccessDefinition);

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
    DefineScreenAccessControl? defineScreenAccessControl,
  })  : _credentialsStorageFactory =
            credentialsStorageFactory ?? ((_) => CredentialsMemoryStorage()),
        _identityProvider = identityProvider {
    if (null != defineAccess) {
      defineAccess(_accessControl);
    }

    if (null != defineScreenAccessControl) {
      defineScreenAccessControl(_screenAccessDefinition);
    }
  }

  final CredentialsStorageFactory _credentialsStorageFactory;

  final IdentityProvider _identityProvider;

  final AccessControl _accessControl = AccessControl();

  late final ScreenAccessDefinition _screenAccessDefinition =
      ScreenAccessDefinition._(_accessControl);

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
      ..routerSettings.refreshNotifierFactories.add(
            (container) => container.read(authManagerProvider),
          );
  }

  Future<void> _boot(ProviderContainer container) async {
    await container.read(userProvider).refreshIdentity();
  }

  Override _authManagerOverride() {
    return authManagerProvider.overrideWith((ref) {
      final auth = AuthManager(
        credentialsStorage: _credentialsStorageFactory(ref.container),
        eventManager: ref.read(eventManagerProvider),
      );

      void onStateChange() => ref.notifyListeners();

      ref.onDispose(() => auth.removeListener(onStateChange));

      auth.addListener(onStateChange);

      return auth;
    });
  }

  Override _userOverride() {
    return userProvider.overrideWith(
      (ref) {
        final em = ref.read(eventManagerProvider);
        final user = User(
          accessControl: _accessControl,
          authManager: ref.read(authManagerProvider),
          eventManager: em,
          identityProvider: (credentials) => _identityProvider(
            credentials,
            ref.container,
          ),
        );

        Future<void> onAuthEvent(_) => user.refreshIdentity();
        void onRefreshIdentity(_) => ref.notifyListeners();

        ref.onDispose(
          () => em
            ..removeEventListener<IdentityChangedEvent>(onRefreshIdentity)
            ..removeEventListener<LoggedInEvent>(onAuthEvent)
            ..removeEventListener<LoggedOutEvent>(onAuthEvent),
        );

        em
          ..addEventListener<IdentityChangedEvent>(
            onRefreshIdentity,
            priority: 8,
          )
          ..addEventListener<LoggedInEvent>(
            onAuthEvent,
            priority: 8,
          )
          ..addEventListener<LoggedOutEvent>(
            onAuthEvent,
            priority: 8,
          );

        return user;
      },
    );
  }

  Override _accessDefinitionOverride() {
    return accessDefinitionProvider.overrideWithValue(_accessControl);
  }

  Override _accessControlOverride() {
    return accessControlProvider.overrideWithValue(_accessControl);
  }
}
