# Robusta Firebase Cloud Messaging

Providing bridge to integrate Robusta with [Firebase Cloud Messaging](https://firebase.flutter.dev/docs/messaging/overview/).

# Prerequisites:

Please refer to FlutterFire docs for init configuration (https://firebase.flutter.dev/docs/overview)

## Installation

Install this package via pub command:

```
flutter pub add robusta_firebase_cloud_messaging
```

## Usages

Add `FirebaseCoreExtension` to runner:
Add `FirebaseCloudMessaging` to runner:

```dart
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_firebase_cloud_messaging/robusta_cloud_messaging.dart';

final runner = Runner(
 extensions: [
  //....
    const FirebaseCoreExtension(),
    FirebaseCloudMessagingExtension(
      eventManager: DefaultEventManager(),
    ),
  ],
);

Future<void> main() => runner.run();
```
