import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_firebase_messaging/robusta_firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _bgMessageHandler(RemoteMessage message) async {
  print('HI FROM BG: ${message.notification?.title}');
}

/// runner
final runner = Runner(
  extensions: [
    EventExtension(
      configurator: (em, container) {
        em.addEventListener<OnMessageEvent>((message) {
          print('Message Comes From FB: ${message.source.name} \n'
              '- ${message.message.notification?.title}');
        });
      },
    ),
    const FirebaseCoreExtension(),
    FirebaseMessagingExtension(backgroundMessageHandler: _bgMessageHandler),
  ],
);

Future<void> main() => runner.run();
