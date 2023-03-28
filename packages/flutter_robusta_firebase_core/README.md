# Flutter Robusta Firebase Core

Providing bridge to integrate Robusta with [Flutter Firebase Core](https://firebase.flutter.dev/docs/core).

# Prerequisites:

Please refer to FlutterFire docs for init configuration (https://firebase.flutter.dev/docs/overview)

## Installation

Install this package via pub command:

```
flutter pub add flutter_robusta_firebase_core
```

## Usages

Add `FlutterFirebaseCoreExtension` to runner:

```dart
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_firebase_core/flutter_robusta_firebase_core.dart';

final runner = Runner(
  extensions: [
    // ...
    const FlutterFirebaseCoreExtension(),
  ],
);

Future<void> main() => runner.run();
```
