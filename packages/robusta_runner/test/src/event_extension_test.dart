import 'package:riverpod/riverpod.dart';
import 'package:robusta_runner/robusta_runner.dart';
import 'package:test/test.dart';

import 'stub.dart';

void main() {
  group('event extension', () {
    test('can initialize', () {
      final e = EventExtension({});

      expect(e, isNotNull);
    });

    test('can add listeners', () async {
      var counter = 0;

      void boot(ProviderContainer c) {
        c.read(eventManagerProvider).dispatchEvent(TestEvent());
      }

      final runner = Runner(
        extensions: [
          EventExtension(
            {
              (TestEvent e) {
                counter++;
              }: 1,
            },
          ),
          EventExtension(
            {
                  (RunEvent e) {
                counter += 2;
              }: 1,
            },
          ),
        ],
        boots: {boot: 0},
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
            EventExtension({}),
            ImplementingCallbackExtension(),
          ],
          boots: {
            (c) => test = c.read(testProvider): 0,
          },
        );

        await runner.run();

        expect(test, isNotNull);
        expect(test!.em, isNotNull);
      },
    );
  });
}
