import 'package:riverpod/riverpod.dart';
import 'package:robusta_runner/robusta_runner.dart';

class TestExtension implements Extension {
  @override
  void load(Configurator configurator) {}
}

class TestEvent extends Event {}

class Test implements EventManagerAware {
  EventManager? em;

  @override
  void setEventManager(EventManager manager) => em = manager;
}

final testProvider = Provider<Test>((_) => Test());
