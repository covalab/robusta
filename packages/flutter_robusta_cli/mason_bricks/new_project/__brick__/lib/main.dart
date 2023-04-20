import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:{{package_name}}/robusta/app.dart';
import 'package:{{package_name}}/robusta/boot.dart';
import 'package:{{package_name}}/robusta/event.dart';

Future<void> main() async {
  final runner = Runner(
    defineBoot: defineBoot,
    extensions: [
      ImplementingCallbackExtension(),
      appExtension(),
      eventExtension(),
    ],
  );

  await runner.run();
}
