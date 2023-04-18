import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_firebase_messaging/robusta_firebase_messaging.dart';

/// runner
final runner = Runner(
  extensions: [
    const FirebaseCoreExtension(),
    const FirebaseMessagingExtension(),
  ],
);

Future<void> main() => runner.run();
