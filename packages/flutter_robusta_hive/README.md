Flutter Robusta Hive
====================

Providing bridge to integrate Robusta with [Flutter Hive storage](https://docs.hivedb.dev).

Installation
------------

Install this package via pub command:

```
flutter pub add flutter_robusta_hive
```

Usages
------

Add `FlutterHiveExtension` to runner:

```dart
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';

final runner = Runner(
  extensions: [
    ///...
    FlutterHiveExtension(),
  ],
);

Future<void> main() => runner.run();
```