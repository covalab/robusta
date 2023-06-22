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
      FlutterGraphQLExtension flutterGraphQLExtension() {
        return FlutterGraphQLExtension(
          settings: GraphQLClientSettings(
            linkFactory: (c) => throw UnimplementedError(),
            cacheFactory: (c) => throw UnimplementedError(),
          ),
        );
      }

      expect(
        () => Runner(
          extensions: [flutterGraphQLExtension],
        ),
        throwsA(isA<RunnerException>()),
      );
    });

    test(
      'can use without FlutterAppExtension when disable graphql provider',
      () {
        FlutterGraphQLExtension flutterGraphQLExtension() {
          return FlutterGraphQLExtension(
            enabledGraphQLProvider: false,
            settings: GraphQLClientSettings(
              linkFactory: (c) => throw UnimplementedError(),
              cacheFactory: (c) => throw UnimplementedError(),
            ),
          );
        }

        expect(
          () => Runner(
            extensions: [flutterGraphQLExtension],
          ),
          returnsNormally,
        );
      },
    );

    testWidgets('runner can run without errors', (tester) async {
      GraphQLClient? client;

      FlutterAppExtension flutterAppExtension() {
        return FlutterAppExtension(routerSettings: RouterSettings());
      }

      FlutterGraphQLExtension flutterGraphQLExtension() {
        return FlutterGraphQLExtension(
          settings: GraphQLClientSettings(
            linkFactory: (c) => Link.from([HttpLink('')]),
            cacheFactory: (c) => GraphQLCache(),
          ),
        );
      }

      final runner = Runner(
        defineBoot: (def) {
          def((c) {
            client = c.read(graphQLClientProvider);
          });
        },
        extensions: [
          flutterAppExtension,
          flutterGraphQLExtension,
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
      FlutterAppExtension flutterAppExtension() {
        return FlutterAppExtension(routerSettings: RouterSettings());
      }

      FlutterGraphQLExtension flutterGraphQLExtension() {
        return FlutterGraphQLExtension(
          enabledGraphQLProvider: false,
          settings: GraphQLClientSettings(
            linkFactory: (c) => Link.from([HttpLink('')]),
            cacheFactory: (c) => GraphQLCache(),
          ),
        );
      }

      final runner = Runner(
        extensions: [
          flutterAppExtension,
          flutterGraphQLExtension,
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
        FlutterAppExtension flutterAppExtension() {
          return FlutterAppExtension(routerSettings: RouterSettings());
        }

        FlutterGraphQLExtension flutterGraphQLExtension() {
          return FlutterGraphQLExtension(
            settings: GraphQLClientSettings(
              linkFactory: (c) => Link.from([HttpLink('')]),
              cacheFactory: (c) => GraphQLCache(),
            ),
          );
        }

        Test? testService;

        final runner = Runner(
          defineBoot: (def) {
            def((c) => testService = c.read(testProvider));
          },
          extensions: [
            ImplementingCallbackExtension.new,
            flutterAppExtension,
            flutterGraphQLExtension,
          ],
        );

        await expectLater(tester.runAsync(runner.run), completes);

        expect(testService, isNotNull);
        expect(testService!.graphQLClient, isA<GraphQLClient>());
      },
    );

    testWidgets('can disable init hive on boot', (tester) async {
      FlutterAppExtension flutterAppExtension() {
        return FlutterAppExtension(routerSettings: RouterSettings());
      }

      FlutterGraphQLExtension flutterGraphQLExtension() {
        return FlutterGraphQLExtension(
          initHive: false,
          settings: GraphQLClientSettings(
            linkFactory: (c) => Link.from([HttpLink('')]),
            cacheFactory: (c) => GraphQLCache(),
          ),
        );
      }

      final runner = Runner(
        extensions: [
          flutterAppExtension,
          flutterGraphQLExtension,
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
