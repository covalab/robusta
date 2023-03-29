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

/// {@template flutter_robusta_auth}
/// An extension providing authn/authz features.
/// {@endtemplate}
class FlutterAuthExtension implements DependenceExtension {
  /// {@macro flutter_robusta_auth}
  FlutterAuthExtension({
    bool persistCredentials = true,
    required UserProvider userProvider,
  })  : _persistCredentials = persistCredentials,
        _userProvider = userProvider;

  final bool _persistCredentials;

  final UserProvider _userProvider;

  @override
  List<Type> dependsOn() {
    return [
      if (_persistCredentials) FlutterHiveExtension,
    ];
  }

  @override
  Future<void> load(Configurator configurator) async {
    configurator
      ..addContainerOverride(await _authManagerOverride())
      ..addContainerOverride(_userFamilyOverride())
      ..addContainerOverride(_currentUserOverride())
      ..addBoot(_boot);
  }

  Future<void> _boot(ProviderContainer container) async {
    final authManager = container.read(authManagerProvider);

    if (null != authManager.currentCredentials) {
      final currentUser = await _userProvider(
        authManager.currentCredentials!,
        container,
      );

      container.read(currentUserProvider.notifier).state = currentUser;
    }
  }

  Override _currentUserOverride() => currentUserProvider.overrideWith(
        (ref) => null,
      );

  Override _userFamilyOverride() {
    return userFamily.overrideWith((ref, credentials) async {
      final em = ref.read(eventManagerProvider);
      void onLogout(LogoutEvent event) => ref.invalidateSelf();
      ref.onDispose(() => em.removeEventListener<LogoutEvent>(onLogout));
      em.addEventListener<LogoutEvent>(onLogout);

      return _userProvider(credentials, ref.container);
    });
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
      void onLogin(LoginEvent event) {
        ref.read(currentUserProvider.notifier).state = event.currentUser;
      }

      void onLogout(LogoutEvent event) {
        ref.read(currentUserProvider.notifier).state = null;
      }

      final em = ref.read(eventManagerProvider)
        ..addEventListener<LoginEvent>(onLogin)
        ..addEventListener<LogoutEvent>(onLogout);

      ref.onDispose(() {
        em
          ..removeEventListener<LoginEvent>(onLogin)
          ..removeEventListener<LogoutEvent>(onLogout);
        box?.close();
      });

      return AuthManager(
        userProvider: (credentials) => ref.read(userFamily(credentials)),
        credentialsStorage: CredentialsStorage(box: box),
        eventManager: em,
      );
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
