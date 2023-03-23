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
      expect(() => FlutterHiveExtension(), returnsNormally);
    });

    test('cause error when open box but not have extension', () async {
      var hasError = false;

      final runner = Runner(
        extensions: [
          EventExtension<RunEvent>({
            (e) => expectLater(() => Hive.openBox('test'), returnsNormally): 0,
          }),
          EventExtension<ExceptionEvent>({
            (e) => hasError = true: 0,
          }),
        ],
      );

      await runner.run();

      expect(hasError, isTrue);
    });

    test('can open box when have extension', () async {
      final runner = Runner(
        extensions: [
          FlutterHiveExtension(),
          EventExtension<RunEvent>({
            (e) => expectLater(() => Hive.openBox('test'), returnsNormally): 0,
          }),
        ],
      );

      await runner.run();
    });
  });
}
