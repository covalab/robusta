import 'package:riverpod/riverpod.dart';
import 'package:robusta_runner/robusta_runner.dart';
import 'package:test/test.dart';

import 'stub.dart';

void main() {
  group('event extension', () {
    test('can initialize', () {
      final e = EventExtension(
        configurator: (e, c) {},
      );

      expect(e, isNotNull);
    });

    test('can add listeners', () async {
      var counter = 0;

      final runner = Runner(
        extensions: [
          EventExtension(
            configurator: (em, c) {
              em
                ..addEventListener<TestEvent>((_) => counter++, priority: 1)
                ..addEventListener<TestEvent>((_) => counter += 2, priority: 1);
            },
          ),
        ],
        defineBoot: (def) {
          def((c) => c.read(eventManagerProvider).dispatchEvent(TestEvent()));
        },
      );

      await runner.run();

      expect(counter, equals(3));
    });

    test(
      'when implementing EventManagerAware, setEventManager should be call',
      () async {
        Test? test;

        final runner = Runner(
          extensions: [
            ImplementingCallbackExtension(),
          ],
          defineBoot: (def) {
            def((c) => test = c.read(testProvider));
          },
        );

        await runner.run();

        expect(test, isNotNull);
        expect(test!.em, isNotNull);
      },
    );
  });
}
