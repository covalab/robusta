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
        boots: {
          (_) => counter++: 1,
        },
      );

      expect(r, isNotNull);
      expect(counter, equals(0));
      await r.run();
      expect(counter, equals(1));
    });

    test('can read providers on boot phase', () async {
      final r = Runner(
        boots: {
          (c) {
            expect(() => c.read(eventManagerProvider), returnsNormally);
            expect(() => c.read(loggerProvider), returnsNormally);
          }: 0,
        },
      );

      await r.run();
    });

    test('can handle run event', () async {
      var counter = 0;

      final r = Runner(
        boots: {
          (c) {
            c.read(eventManagerProvider).addEventListener((RunEvent e) {
              counter++;
            });
          }: 0,
        },
      );

      expect(counter, equals(0));
      await r.run();
      expect(counter, equals(1));
    });

    test('work with extensions', () async {
      var counter = 0;

      final r = Runner(
        logger: Logger(
          output: MemoryOutput(),
        ),
        extensions: [
          EventExtension(
            configurator: (em, c) {
              em
                ..addEventListener<RunEvent>(
                  (e) {
                    counter++;
                    throw Exception();
                  },
                )
                ..addEventListener<ExceptionEvent>((e) {
                  counter++;
                });
            },
          ),
        ],
      );

      expect(counter, equals(0));

      unawaited(r.run());

      await expectLater(
        Future.delayed(Duration.zero, () => counter),
        completion(equals(2)),
      );
    });

    test('use custom dependencies', () async {
      final logger = Logger();
      final em = DefaultEventManager();
      final r = Runner(
        eventManager: em,
        logger: logger,
        boots: {
          (c) {
            expect(c.read(loggerProvider), equals(logger));
            expect(c.read(eventManagerProvider), equals(em));
          }: 0,
        },
      );

      await r.run();
    });

    test('can order boots by priority', () async {
      var counter = 0;

      final r = Runner(
        boots: {
          (_) {
            expect(counter, equals(100));
            counter += 10;
          }: 9,
          (_) {
            expect(counter, equals(0));
            counter += 100;
          }: 99,
          (_) {
            expect(counter, equals(110));
            counter += 1000;
          }: -9,
        },
      );

      await r.run();

      expect(counter, equals(1110));
    });

    test('missing extension dependencies cause exception', () {
      expect(
        () => Runner(
          extensions: [
            TestDependenceExtension(),
          ],
        ),
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
            ImplementingCallbackExtension(),
            TestDependenceExtension(),
          ],
        ),
        returnsNormally,
      );
    });
  });
}
