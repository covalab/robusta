// ignore_for_file: lines_longer_than_80_chars

import 'package:robusta_events/robusta_events.dart';
import 'package:test/test.dart';

import 'event.dart';

void main() {
  group('event base', () {
    test('can be instantiated', () {
      expect(TestEvent(), isNotNull);
    });

    test('can stop propagation', () {
      final e = TestEvent();
      expect(e.isPropagationStopped, isFalse);
      e.stopPropagation();
      expect(e.isPropagationStopped, isTrue);
    });
  });

  group('event store', () {
    test('can mutate store', () async {
      final store = EventStore<TestEvent>();
      void testListener(TestEvent e) {}

      expect(store.eventListeners.length, equals(0));

      store.addEventListener(testListener);

      expect(store.eventListeners.length, equals(1));

      store.removeEventListener(testListener);

      expect(store.eventListeners.length, equals(0));
    });

    test('can order by priority', () async {
      final store = EventStore<TestEvent>();
      void first(TestEvent e) {}
      void second(TestEvent e) {}
      void third(TestEvent e) {}

      expect(store.eventListeners.length, equals(0));

      store
        ..addEventListener(second, priority: 9)
        ..addEventListener(third)
        ..addEventListener(first, priority: 99);

      final listeners = store.eventListeners.toList();

      expect(listeners[0], equals(first));
      expect(listeners[1], equals(second));
      expect(listeners[2], equals(third));
    });
  });
}
