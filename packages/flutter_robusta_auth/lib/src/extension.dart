import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/auth.dart';
import 'package:flutter_robusta_auth/src/provider.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

/// {@template flutter_robusta_auth}
/// An extension providing authn/authz features.
/// {@endtemplate}
@sealed
class FlutterAuthExtension implements DependenceExtension {
  /// {@macro flutter_robusta_auth}
  FlutterAuthExtension({
    bool persistCredentials = true,
    required IdentityProvider identityProvider,
  })  : _persistCredentials = persistCredentials,
        _identityProvider = identityProvider;

  final bool _persistCredentials;

  final IdentityProvider _identityProvider;

  @override
  List<Type> dependsOn() {
    return [
      if (_persistCredentials) FlutterHiveExtension,
    ];
  }

  @override
  Future<void> load(Configurator configurator) async {
    configurator
      ..addBoot(_boot, priority: 8)
      ..addContainerOverride(_userOverride())
      ..addContainerOverride(await _authManagerOverride());
  }

  Future<void> _boot(ProviderContainer container) async {
    await container.read(userProvider).refreshIdentity();
  }

  Override _userOverride() {
    return userProvider.overrideWith(
      (ref) {
        final em = ref.read(eventManagerProvider);
        final user = User(
          authManager: ref.read(authManagerProvider),
          eventManager: ref.read(eventManagerProvider),
          identityProvider: (credentials) => _identityProvider(
            credentials,
            ref.container,
          ),
        );

        Future<void> onAuthEvent(_) => user.refreshIdentity();
        void onRefreshIdentity(_) => ref.notifyListeners();

        ref.onDispose(
          () => em
            ..removeEventListener<IdentityRefreshEvent>(onRefreshIdentity)
            ..removeEventListener<LoggedInEvent>(onAuthEvent)
            ..removeEventListener<LoggedOutEvent>(onAuthEvent),
        );

        em
          ..addEventListener<IdentityRefreshEvent>(
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

  Future<Override> _authManagerOverride() async {
    Box<String>? box;

    if (_persistCredentials) {
      box = await Hive.openBox<String>(
        'flutter_robusta_auth',
        encryptionCipher: HiveAesCipher(
          await _upsertHiveBoxSecureKey(),
        ),
      );
    }

    return authManagerProvider.overrideWith((ref) {
      final auth = AuthManager(
        credentialsStorage: CredentialsStorage(box: box),
        eventManager: ref.read(eventManagerProvider),
      );

      void onStateChange() => ref.notifyListeners();

      ref.onDispose(() {
        box?.close();
        auth.removeListener(onStateChange);
      });

      auth.addListener(onStateChange);

      return auth;
    });
  }

  Future<Uint8List> _upsertHiveBoxSecureKey() async {
    const secureStorage = FlutterSecureStorage();
    const aOptions = AndroidOptions(
      resetOnError: true,
      encryptedSharedPreferences: true,
    );

    var key = await secureStorage.read(
      key: 'flutter_robusta_auth',
      aOptions: aOptions,
    );

    if (key == null) {
      await secureStorage.write(
        key: 'flutter_robusta_auth',
        value: base64Url.encode(Hive.generateSecureKey()),
        aOptions: aOptions,
      );

      key = await secureStorage.read(
        key: 'flutter_robusta_auth',
        aOptions: aOptions,
      );
    }

    return base64Url.decode(key!);
  }
}
