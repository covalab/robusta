import 'dart:async';

import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';

/// {@template credentials_hive_storage}
/// Credentials persistent storage for auth extension,
/// Auth credentials will store by Hive when terminated app and reopen,
/// previous credentials still keep.
/// {@endtemplate}
class CredentialsHiveStorage implements CredentialsStorage {
  /// {@macro credentials_hive_storage}
  CredentialsHiveStorage({required Box<String> box}) : _box = box;

  final Box<String> _box;

  @override
  Future<void> delete() async => _box.clear();

  @override
  Map<String, String>? read() {
    if (_box.isEmpty) {
      return null;
    }

    final credentials = <String, String>{};

    for (final key in _box.keys) {
      credentials[key as String] = _box.get(key)!;
    }

    return credentials;
  }

  @override
  Future<void> write(Map<String, String> credentials) async {
    await delete();
    await Future.wait(
      credentials.entries.map(
        (e) => _box.put(e.key, e.value),
      ),
    );
  }
}
