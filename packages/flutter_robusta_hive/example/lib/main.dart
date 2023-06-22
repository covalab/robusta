import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';

final runner = Runner(
  extensions: [
    FlutterHiveExtension.new,
  ],
);

Future<void> main() => runner.run();
