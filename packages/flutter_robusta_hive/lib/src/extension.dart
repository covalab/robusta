import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// {@template flutter_hive_extension}
/// Help to initialize Hive.
/// {@endtemplate}
class FlutterHiveExtension implements Extension {
  /// {@macro flutter_hive_extension}
  FlutterHiveExtension({String? subDir}) : _subDir = subDir;

  final String? _subDir;

  @override
  void load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 8191);
  }

  Future<void> _boot(_) => Hive.initFlutter(_subDir);
}
