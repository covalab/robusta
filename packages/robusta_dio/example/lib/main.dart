import 'package:robusta_dio/robusta_dio.dart';
import 'package:robusta_runner/robusta_runner.dart';

DioExtension dioExtension() {
  return DioExtension(
    baseOptions: BaseOptions(),
    interceptorFactories: [
      (c) => InterceptorsWrapper(),
    ],
    transformerFactory: (c) => BackgroundTransformer(),
    httpClientAdapterFactory: (c) => HttpClientAdapter(),
  );
}

final runner = Runner(
  extensions: [
    ImplementingCallbackExtension.new,
    dioExtension,
  ],
);

Future<void> main() => runner.run();
