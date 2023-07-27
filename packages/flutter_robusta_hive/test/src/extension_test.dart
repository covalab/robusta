import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:robusta_runner/robusta_runner.dart';

import 'fake.dart';

void main() {
  setUp(() {
    PathProviderPlatform.instance = FakePathProviderPlatform();
  });

  group('flutter robusta hive', () {
    test('can init extension', () {
      expect(FlutterHiveExtension.new, returnsNormally);
    });

    test('cause error when open box but not have extension', () async {
      var hasError = false;

      EventExtension eventExtension() {
        return EventExtension(
          configurator: (em, c) {
            em
              ..addEventListener<RunEvent>(
                (e) => Hive.openBox<String>('test'),
              )
              ..addEventListener<ErrorEvent>((e) {
                hasError = true;
              });
          },
        );
      }

      final runner = Runner(
        extensions: [eventExtension],
      );

      // unawaited(runner.run());

      await expectLater(runner.run(), throwsA(isA<HiveError>()));

      // expect(hasError, isTrue);

      await expectLater(
        Future.delayed(Duration.zero, () => hasError),
        completion(isTrue),
      );
    });

    test('can open box when have extension', () async {
      EventExtension eventExtension() {
        return EventExtension(
          configurator: (em, c) {
            em.addEventListener<RunEvent>(
              (e) => expectLater(Hive.openBox<String>('test'), completes),
            );
          },
        );
      }

      final runner = Runner(
        extensions: [
          FlutterHiveExtension.new,
          eventExtension,
        ],
      );

      await expectLater(runner.run(), completes);
    });
  });
}
