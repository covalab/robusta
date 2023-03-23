import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// {@template flutter_hive_extension}
/// Help to initial Hive and add adapters.
/// {@endtemplate}
class FlutterHiveExtension implements Extension {
  /// {@macro flutter_hive_extension}
  FlutterHiveExtension({List<TypeAdapter>? typeAdapters})
      : _typeAdapters = [...?typeAdapters];

  final List<TypeAdapter> _typeAdapters;

  @override
  Future<void> load(Configurator configurator) async {
    await Hive.initFlutter();

    for (final adapter in _typeAdapters) {
      Hive.registerAdapter(adapter);
    }
  }
}
