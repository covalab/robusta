import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:flutter_robusta_hive_auth/flutter_robusta_hive_auth.dart';

final runner = Runner(
  extensions: [
    FlutterHiveExtension(),
    FlutterHiveAuthExtension(),
    FlutterAuthExtension(
      identityProvider: (credentials, provider) => throw UnimplementedError(),
      credentialsStorageFactory: (c) => c.read(credentialsHiveStorageProvider),
    )
  ],
);

Future<void> main() => runner.run();
