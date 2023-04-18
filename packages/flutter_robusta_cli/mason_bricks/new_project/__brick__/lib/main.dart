import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:{{package_name}}/robusta/app.dart';

Future<void> main() async {
  final runner = Runner(
    extensions: [
      appExtension(),
    ],
  );

  await runner.run();
}
