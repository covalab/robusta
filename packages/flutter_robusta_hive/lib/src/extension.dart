import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  void load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 8191);
  }

  Future<void> _boot(ProviderContainer container) async {
    await Hive.initFlutter();

    for (final adapter in _typeAdapters) {
      Hive.registerAdapter(adapter);
    }
  }
}
