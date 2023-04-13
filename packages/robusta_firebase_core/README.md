# Robusta Firebase Core

Providing bridge to integrate Robusta with [Firebase Core](https://firebase.flutter.dev/docs/core).

# Prerequisites:

Please refer to FlutterFire docs for init configuration (https://firebase.flutter.dev/docs/overview)

## Installation

Install this package via pub command:

```
flutter pub add robusta_firebase_core
```

## Usages

Add `FirebaseCoreExtension` to runner:

```dart
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';

final runner = Runner(
  extensions: [
    // ...
    const FirebaseCoreExtension(),
  ],
);

Future<void> main() => runner.run();
```
