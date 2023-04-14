import 'package:robusta_dio/robusta_dio.dart';
import 'package:robusta_runner/robusta_runner.dart';
import 'package:test/test.dart';

import 'stub.dart';

void main() {
  group('dio extension', () {
    test('can initialize', () {
      expect(DioExtension.new, returnsNormally);
    });

    test('constructor of extension can affect provider', () async {
      final interceptorsWrapper = InterceptorsWrapper();
      final httpClientAdapter = HttpClientAdapter();
      final transformer = BackgroundTransformer();

      Dio? dio;

      final runner = Runner(
        defineBoot: (def) {
          def((container) {
            dio = container.read(dioProvider);
          });
        },
        extensions: [
          DioExtension(
            baseOptions: BaseOptions(baseUrl: 'dio://example'),
            interceptorFactories: [
              (c) => interceptorsWrapper,
            ],
            transformerFactory: (c) => transformer,
            httpClientAdapterFactory: (c) => httpClientAdapter,
          ),
        ],
      );

      await expectLater(runner.run(), completes);

      expect(dio, isNotNull);
      expect(dio!.options.baseUrl, equals('dio://example'));
      expect(dio!.interceptors.contains(interceptorsWrapper), isTrue);
      expect(dio!.transformer, transformer);
      expect(dio!.httpClientAdapter, httpClientAdapter);
    });

    test('auto set dio when using implementing callback extension', () async {
      Repository? repository;

      final runner = Runner(
        defineBoot: (def) {
          def((container) {
            repository = container.read(repositoryProvider);
          });
        },
        extensions: [
          DioExtension(),
          ImplementingCallbackExtension(),
        ],
      );

      await expectLater(runner.run(), completes);

      expect(repository, isNotNull);
      expect(repository!.dio, isA<Dio>());
    });
  });
}
