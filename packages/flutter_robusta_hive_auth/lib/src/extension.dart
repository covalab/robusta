import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:flutter_robusta_hive_auth/src/provider.dart';
import 'package:flutter_robusta_hive_auth/src/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// {@template flutter_robusta_hive_auth}
/// Integrating Hive features with Robusta auth extension.
/// {@endtemplate}
class FlutterHiveAuthExtension implements DependenceExtension {
  /// {@macro flutter_robusta_hive_auth}
  FlutterHiveAuthExtension({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                resetOnError: true,
                encryptedSharedPreferences: true,
              ),
            );

  final FlutterSecureStorage _secureStorage;

  late final Box<String> _secureBox;

  @override
  List<Type> dependsOn() => [FlutterHiveExtension];

  @override
  Future<void> load(Configurator configurator) async {
    configurator
      ..addBoot(_boot, priority: 8190)
      ..addContainerOverride(_credentialsHiveStorageOverride());
  }

  Future<void> _boot(ProviderContainer container) async {
    final encryptKey = await _upsertSecureKey();

    _secureBox = await Hive.openBox<String>(
      'flutter_robusta_hive_auth',
      encryptionCipher: HiveAesCipher(encryptKey),
    );
  }

  Override _credentialsHiveStorageOverride() {
    return credentialsHiveStorageProvider.overrideWith(
      (ref) {
        ref.onDispose(_secureBox.close);

        return CredentialsHiveStorage(box: _secureBox);
      },
    );
  }

  Future<Uint8List> _upsertSecureKey() async {
    var key = await _secureStorage.read(key: 'flutter_robusta_hive_auth');

    if (key == null) {
      await _secureStorage.write(
        key: 'flutter_robusta_hive_auth',
        value: base64Url.encode(Hive.generateSecureKey()),
      );

      key = await _secureStorage.read(key: 'flutter_robusta_hive_auth');
    }

    return base64Url.decode(key!);
  }
}
