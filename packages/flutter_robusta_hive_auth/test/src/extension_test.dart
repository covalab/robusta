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
        () async => Runner(extensions: [FlutterHiveAuthExtension.new]).run(),
        throwsA(
          isA<RunnerException>(),
        ),
      );

      expect(
        () => Runner(
          extensions: [
            FlutterHiveAuthExtension.new,
            FlutterHiveExtension.new,
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

      FlutterAppExtension flutterAppExtension() {
        return FlutterAppExtension(routerSettings: RouterSettings());
      }

      FlutterHiveAuthExtension flutterHiveAuthExtension() {
        return FlutterHiveAuthExtension(
          secureStorage: storage,
        );
      }

      FlutterAuthExtension flutterAuthExtension() {
        return FlutterAuthExtension(
          credentialsStorageFactory: (c) => c.read(
            credentialsHiveStorageProvider,
          ),
          identityProvider: (credentials, container) => Identity(
            id: '1',
            data: {},
          ),
        );
      }

      EventExtension eventExtension() {
        return EventExtension(
          configurator: (em, c) {
            em.addEventListener<RunEvent>((e) async {
              await c.read(authManagerProvider).loginByCrendentials(
                {'access': 'token'},
              );
            });
          },
        );
      }

      final runner = Runner(
        extensions: [
          flutterAppExtension,
          flutterHiveAuthExtension,
          FlutterHiveExtension.new,
          flutterAuthExtension,
          eventExtension,
        ],
      );

      await expectLater(tester.runAsync(runner.run), completes);
    });
  });
}
