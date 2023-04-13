import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:robusta_runner/robusta_runner.dart';

class TestExtension implements Extension {
  @override
  void load(Configurator configurator) {}
}

class TestDependenceExtension implements DependenceExtension {
  @override
  List<Type> dependsOn() => [ImplementingCallbackExtension];

  @override
  FutureOr<void> load(Configurator configurator) {
    configurator.defineImplementingCallback(
      (Test testImpl, _) => testImpl.num = 1,
    );
  }
}

class TestEvent extends Event {}

class Test implements EventManagerAware, LoggerAware {
  int num = 0;

  EventManager? em;

  Logger? logger;

  @override
  void setEventManager(EventManager manager) => em = manager;

  @override
  void setLogger(Logger logger) => this.logger = logger;
}

final testProvider = Provider<Test>((_) => Test());
