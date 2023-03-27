import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_firebase_core/flutter_robusta_firebase_core.dart';

final runner = Runner(
  extensions: [
    const FlutterFirebaseCoreExtension(),
  ],
);

Future<void> main() => runner.run();
