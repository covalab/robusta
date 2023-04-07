import 'dart:convert';

import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:flutter_robusta_hive_auth/flutter_robusta_hive_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'fake.dart';
import 'mocks/main.mocks.dart';

void main() {
  group('Flutter hive auth extension', () {
    setUp(() {
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });

    test('can initialize', () {
      expect(FlutterHiveAuthExtension.new, returnsNormally);
    });

    test('can initialize', () {
      expect(FlutterHiveAuthExtension.new, returnsNormally);
    });

    test('can not uses without FlutterHiveExtension', () {
      expect(
        () => Runner(extensions: [FlutterHiveAuthExtension()]),
        throwsA(isA<RunnerException>()),
      );

      expect(
        () => Runner(
          extensions: [
            FlutterHiveAuthExtension(),
            FlutterHiveExtension(),
          ],
        ),
        returnsNormally,
      );
    });

    testWidgets('integrate with auth extension', (tester) async {
      final storage = MockFlutterSecureStorage();

      when(storage.read(key: 'flutter_robusta_hive_auth')).thenAnswer(
        (realInvocation) async => base64Encode(Hive.generateSecureKey()),
      );

      await storage.read(key: 'flutter_robusta_hive_auth');
      final runner = Runner(
        extensions: [
          FlutterAppExtension(routerSettings: RouterSettings()),
          FlutterHiveAuthExtension(
            secureStorage: storage,
          ),
          FlutterHiveExtension(),
          FlutterAuthExtension(
            credentialsStorageFactory: (c) => c.read(
              credentialsHiveStorageProvider,
            ),
            identityProvider: (credentials, container) => Identity(
              id: '1',
              data: {},
            ),
          ),
          EventExtension(
            configurator: (em, c) {
              em.addEventListener<RunEvent>((e) async {
                await c.read(authManagerProvider).loginByCrendentials(
                  {'access': 'token'},
                );
              });
            },
          ),
        ],
      );

      await expectLater(tester.runAsync(runner.run), completes);
    });
  });
}
