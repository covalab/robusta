# Robusta Firebase Messaging

Providing bridge to integrate Robusta with [Firebase Cloud Messaging](https://firebase.flutter.dev/docs/messaging/overview/).

# Prerequisites:

Please refer to FlutterFire docs for init configuration (https://firebase.flutter.dev/docs/overview)

## Installation

Install this package via pub command:

```
flutter pub add robusta_firebase_messaging
```

## Usages

Add `FirebaseCoreExtension` to runner:
Add `FirebaseMessagingExtension` to runner:

```dart
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_firebase_messaging/robusta_firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _bgMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('HI FROM BG: ${message.notification?.title}');
  }
}

final runner = Runner(
 extensions: [
  //....
    EventExtension(configurator: (em, container) {
      em.addEventListener<OnMessageEvent>((message) {
        print('Message Comes From FB: ${message.source.name} \n'
            '- ${message.message.notification?.title}');
      });
    }),
    const FirebaseCoreExtension(),
    FirebaseMessagingExtension(backgroundMessageHandler: _bgMessageHandler),
  ],
);

Future<void> main() => runner.run();
```
