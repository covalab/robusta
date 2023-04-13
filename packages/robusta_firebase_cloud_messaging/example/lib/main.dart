import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_cloud_messaging/robusta_firebase_cloud_messaging.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';

/// runner
final runner = Runner(
  extensions: [
    const FirebaseCoreExtension(),
    FirebaseCloudMessagingExtension(
      eventManager: DefaultEventManager(),
    ),
  ],
);

Future<void> main() => runner.run();
