Flutter Robusta Hive Auth
=========================
Providing persistent and secure storage for storing auth credentials.

Installation
------------

Install this package via pub command:

```
flutter pub add flutter_robusta_hive_auth
```


Usages
------

```dart
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
```