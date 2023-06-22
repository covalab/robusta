import 'package:flutter/foundation.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_firebase_messaging/robusta_firebase_messaging.dart';

/// Handle background message from Firebase Messaging
@pragma('vm:entry-point')
Future<void> bgMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('HI FROM BG: ${message.notification?.title}');
  }
}

/// Event Extension
EventExtension eventExtension() {
  return EventExtension(
    configurator: (em, container) {
      em.addEventListener<OnMessageEvent>((message) {
        if (kDebugMode) {
          print('Message Comes From FB: ${message.source.name} \n'
              '- ${message.message.notification?.title}');
        }
      });
    },
  );
}

/// Firebase Messaging Extension
FirebaseMessagingExtension firebaseMessagingExtension() {
  return FirebaseMessagingExtension(backgroundMessageHandler: bgMessageHandler);
}

/// runner
final runner = Runner(
  extensions: [
    eventExtension,
    FirebaseCoreExtension.new,
    firebaseMessagingExtension,
  ],
);

Future<void> main() => runner.run();
