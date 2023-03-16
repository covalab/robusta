import 'package:robusta_events/robusta_events.dart';

/// Test event
class TestEvent extends Event {
  /// Will be increase when this event dispatch.
  int counter = 0;
}

/// Event manager manage the event system.
final eventManager = DefaultEventManager()
  ..addEventListener(
    (TestEvent event) => event.counter++,
  );

void main() {
  final event = TestEvent();

  eventManager.dispatchEvent(event);

  print(event.counter);
}
