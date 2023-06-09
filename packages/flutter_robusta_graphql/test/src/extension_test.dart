import 'dart:io';

import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'fake.dart';
import 'stub.dart';

void main() {
  setUp(() async {
    final instance = PathProviderPlatform.instance = FakePathProviderPlatform();

    final path = await instance.getApplicationDocumentsPath();
    final dir = Directory(path!);

    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  });

  group('flutter graphql extension', () {
    test('can initialize', () {
      expect(
        () => FlutterGraphQLExtension(
          settings: GraphQLClientSettings(
            linkFactory: (c) => throw UnimplementedError(),
            cacheFactory: (c) => throw UnimplementedError(),
          ),
        ),
        returnsNormally,
      );
    });

    test('can not use without FlutterAppExtension', () {
      expect(
        () => Runner(
          extensions: [
            FlutterGraphQLExtension(
              settings: GraphQLClientSettings(
                linkFactory: (c) => throw UnimplementedError(),
                cacheFactory: (c) => throw UnimplementedError(),
              ),
            ),
          ],
        ),
        throwsA(isA<RunnerException>()),
      );
    });

    test(
      'can use without FlutterAppExtension when disable graphql provider',
      () {
        expect(
          () => Runner(
            extensions: [
              FlutterGraphQLExtension(
                enabledGraphQLProvider: false,
                settings: GraphQLClientSettings(
                  linkFactory: (c) => throw UnimplementedError(),
                  cacheFactory: (c) => throw UnimplementedError(),
                ),
              ),
            ],
          ),
          returnsNormally,
        );
      },
    );

    testWidgets('runner can run without errors', (tester) async {
      GraphQLClient? client;

      final runner = Runner(
        defineBoot: (def) {
          def((c) {
            client = c.read(graphQLClientProvider);
          });
        },
        extensions: [
          FlutterAppExtension(routerSettings: RouterSettings()),
          FlutterGraphQLExtension(
            settings: GraphQLClientSettings(
              linkFactory: (c) => Link.from([HttpLink('')]),
              cacheFactory: (c) => GraphQLCache(),
            ),
          ),
        ],
      );

      final hivePath =
          await PathProviderPlatform.instance.getApplicationDocumentsPath();

      final documentDir = Directory(hivePath!);

      expect(documentDir.existsSync(), isFalse);

      await expectLater(tester.runAsync(runner.run), completes);

      expect(client, isA<GraphQLClient>());

      expect(
        tester.allWidgets.any((element) => element is GraphQLProvider),
        isTrue,
      );

      expect(documentDir.existsSync(), isTrue);
    });

    testWidgets('can flag-off graphql provider', (tester) async {
      final runner = Runner(
        extensions: [
          FlutterAppExtension(routerSettings: RouterSettings()),
          FlutterGraphQLExtension(
            enabledGraphQLProvider: false,
            settings: GraphQLClientSettings(
              linkFactory: (c) => Link.from([HttpLink('')]),
              cacheFactory: (c) => GraphQLCache(),
            ),
          ),
        ],
      );

      await expectLater(
        tester.runAsync(runner.run),
        completes,
      );

      expect(
        tester.allWidgets.any((element) => element is GraphQLProvider),
        isFalse,
      );
    });

    testWidgets(
      'can play well with implementing callback extension',
      (tester) async {
        Test? testService;

        final runner = Runner(
          defineBoot: (def) {
            def((c) => testService = c.read(testProvider));
          },
          extensions: [
            ImplementingCallbackExtension(),
            FlutterAppExtension(routerSettings: RouterSettings()),
            FlutterGraphQLExtension(
              settings: GraphQLClientSettings(
                linkFactory: (c) => Link.from([HttpLink('')]),
                cacheFactory: (c) => GraphQLCache(),
              ),
            ),
          ],
        );

        await expectLater(tester.runAsync(runner.run), completes);

        expect(testService, isNotNull);
        expect(testService!.graphQLClient, isA<GraphQLClient>());
      },
    );

    testWidgets('can disable init hive on boot', (tester) async {
      final runner = Runner(
        extensions: [
          FlutterAppExtension(routerSettings: RouterSettings()),
          FlutterGraphQLExtension(
            initHive: false,
            settings: GraphQLClientSettings(
              linkFactory: (c) => Link.from([HttpLink('')]),
              cacheFactory: (c) => GraphQLCache(),
            ),
          ),
        ],
      );

      final hivePath =
          await PathProviderPlatform.instance.getApplicationDocumentsPath();

      final documentDir = Directory(hivePath!);

      expect(documentDir.existsSync(), isFalse);

      await expectLater(tester.runAsync(runner.run), completes);

      expect(documentDir.existsSync(), isFalse);
    });
  });
}
