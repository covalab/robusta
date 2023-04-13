import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:flutter_robusta_hive_auth/flutter_robusta_hive_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'fake.dart';

void main() {
  group('credentials storage', () {
    setUp(() {
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });

    testWidgets('can initialize', (tester) async {
      Box<String>? box;

      await expectLater(tester.runAsync(Hive.initFlutter), completes);
      await expectLater(
        tester.runAsync(
          () async => box = await Hive.openBox<String>('_test_box'),
        ),
        completes,
      );

      expect(() => CredentialsHiveStorage(box: box!), returnsNormally);
    });

    testWidgets('behaviors can work perfectly', (tester) async {
      await tester.runAsync(Hive.initFlutter);

      final box = await tester.runAsync(
        () async => Hive.openBox<String>('_test_box'),
      );
      final storage = CredentialsHiveStorage(box: box!);

      await expectLater(tester.runAsync(storage.delete), completes);

      expect(storage.read(), isNull);

      await expectLater(
        tester.runAsync(
          () => storage.write({'access': 'token'}),
        ),
        completes,
      );

      expect(storage.read(), {'access': 'token'});

      await expectLater(
        tester.runAsync(
              () => storage.write({'refresh': 'token'}),
        ),
        completes,
      );

      expect(storage.read()?.length, equals(1));
      expect(storage.read(), {'refresh': 'token'});
    });
  });
}
