import 'package:logger/logger.dart';
import 'package:robusta_events/robusta_events.dart';
import 'package:test/test.dart';

import 'event.dart';

void main() {
  group('default event manager', () {
    test('isolate store by events', () async {
      final em = DefaultEventManager();
      var counter = 0;

      em
        ..addEventListener((TestEvent e) => counter++)
        ..addEventListener((AnotherTestEvent e) => counter++)
        ..dispatchEvent(TestEvent());

      expect(counter, equals(1));

      em.dispatchEvent(AnotherTestEvent());

      expect(counter, equals(2));
    });

    test('can be work with custom logger', () async {
      final loggerOutput = MemoryOutput();
      final em = DefaultEventManager(
        logger: Logger(
          output: loggerOutput,
        ),
      );
      final event = TestEvent();

      em.addEventListener(
        (TestEvent e) {},
      );

      expect(loggerOutput.buffer.length, equals(0));

      await em.dispatchEvent(event);

      expect(loggerOutput.buffer.length, equals(1));
    });

    test('can stop propagation', () async {
      final loggerOutput = MemoryOutput();
      final em = DefaultEventManager(
        logger: Logger(
          output: loggerOutput,
        ),
      );
      final event = TestEvent();
      var counter = 0;

      em
        ..addEventListener(
          (TestEvent e) => counter++,
        )
        ..addEventListener(
          (TestEvent e) => e.stopPropagation(),
        )
        ..addEventListener(
          (TestEvent e) => counter++,
        );

      expect(counter, equals(0));
      expect(loggerOutput.buffer.length, equals(0));

      await em.dispatchEvent(event);

      expect(counter, equals(1));
      expect(loggerOutput.buffer.length, equals(2));
      expect(
        loggerOutput.buffer.last.lines.any(
          (element) => element.contains('propagation stopped.'),
        ),
        isTrue,
      );
    });
  });
}
