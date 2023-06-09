import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';

final runner = Runner(
  extensions: [
    const FirebaseCoreExtension(),
  ],
);

Future<void> main() => runner.run();
