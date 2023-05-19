---
id: robusta-firebase-messaging
title: Robusta Firebase Messaging
sidebar_position: 11
---

Initialize **[Firebase Cloud Messaging](https://firebase.flutter.dev/docs/messaging/overview)** package through **Firebase Messaging Extension**

### Prerequites 📝

- Firebase configuration must be done with the help of **[FlutterFire CLI](https://firebase.flutter.dev/docs/overview)**.
- **Firebase Core Extension** must be called beforehand

### Installing ⚙️

### Usage

```js
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

### API
