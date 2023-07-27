// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:logger/logger.dart';
import 'package:robusta_runner/robusta_runner.dart';
import 'package:test/test.dart';

import 'stub.dart';

void main() {
  group('runner', () {
    test('can run runner', () async {
      var counter = 0;
      final r = Runner(
        defineBoot: (def) {
          def((_) => counter++);
        },
      );

      expect(r, isNotNull);
      expect(counter, equals(0));
      await r.run();
      expect(counter, equals(1));
    });

    test('can read providers on boot phase', () async {
      EventManager? em;
      Logger? logger;

      final r = Runner(
        defineBoot: (def) {
          def((c) {
            em = c.read(eventManagerProvider);
            logger = c.read(loggerProvider);
          });
        },
      );

      await expectLater(r.run(), completes);

      expect(em, isA<EventManager>());
      expect(logger, isA<Logger>());
    });

    test('can handle run event', () async {
      var counter = 0;

      final r = Runner(
        defineBoot: (def) {
          def((c) {
            c.read(eventManagerProvider).addEventListener((RunEvent e) {
              counter++;
            });
          });
        },
      );

      expect(counter, equals(0));
      await r.run();
      expect(counter, equals(1));
    });

    test('work with extensions', () async {
      var counter = 0;

      EventExtension eventExtension() {
        return EventExtension(
          configurator: (em, c) {
            em
              ..addEventListener<RunEvent>(
                // ignore: void_checks
                (e) {
                  counter += 1;
                  throw Exception();
                },
              )
              ..addEventListener<ErrorEvent>((e) {
                counter++;
              });
          },
        );
      }

      final r = Runner(
        logger: Logger(
          output: MemoryOutput(),
        ),
        extensions: [eventExtension],
      );

      expect(counter, equals(0));

      // unawaited(r.run());
      await expectLater(r.run(), throwsA(isA<Exception>()));

      await expectLater(
        Future.delayed(Duration.zero, () => counter),
        completion(equals(2)),
      );
    });

    test('use custom dependencies', () async {
      final logger = Logger();
      final em = DefaultEventManager();
      Logger? actualLogger;
      EventManager? actualEM;

      final r = Runner(
        eventManager: em,
        logger: logger,
        defineBoot: (def) {
          def((c) {
            actualLogger = c.read(loggerProvider);
            actualEM = c.read(eventManagerProvider);
          });
        },
      );

      await expectLater(r.run(), completes);

      expect(logger, actualLogger);
      expect(em, actualEM);
    });

    test('can order boots by priority', () async {
      var counter = 0;

      final r = Runner(
        defineBoot: (def) {
          def(
            (_) {
              expect(counter, equals(100));
              counter += 10;
            },
            priority: 9,
          );

          def(
            (_) {
              expect(counter, equals(0));
              counter += 100;
            },
            priority: 99,
          );

          def(
            (_) {
              expect(counter, equals(110));
              counter += 1000;
            },
            priority: -9,
          );
        },
      );

      await expectLater(r.run(), completes);

      expect(counter, equals(1110));
    });

    test('missing extension dependencies cause exception', () {
      expect(
        () => Runner(
          extensions: [
            TestDependenceExtension.new,
          ],
        ).run(),
        throwsA(
          predicate(
            (e) => e is RunnerException && e.toString().contains('depends on'),
          ),
        ),
      );
    });

    test('can run with dependence extension', () {
      expect(
        () => Runner(
          extensions: [
            ImplementingCallbackExtension.new,
            TestDependenceExtension.new,
          ],
        ),
        returnsNormally,
      );
    });
  });
}
