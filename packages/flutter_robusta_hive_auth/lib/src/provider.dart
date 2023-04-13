import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';

const _unimplementedErrorMsg =
    'Outside of FlutterHiveAuthExtension, this provider not implemented.';

/// Providing credentials storage using Hive.
final credentialsHiveStorageProvider = Provider<CredentialsStorage>(
  (_) => throw UnimplementedError(_unimplementedErrorMsg),
);
