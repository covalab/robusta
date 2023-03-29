import 'dart:async';

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
    configurator.addImplementingCallback(
          (Test testImpl, _) => testImpl.num = 1,
    );
  }
}

class TestEvent extends Event {}

class Test implements EventManagerAware {
  int num = 0;

  EventManager? em;

  @override
  void setEventManager(EventManager manager) => em = manager;
}

final testProvider = Provider<Test>((_) => Test());
