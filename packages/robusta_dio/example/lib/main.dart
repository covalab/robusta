import 'package:robusta_dio/robusta_dio.dart';
import 'package:robusta_runner/robusta_runner.dart';

final runner = Runner(
  extensions: [
    ImplementingCallbackExtension(),
    DioExtension(
      baseOptions: BaseOptions(),
      interceptorFactories: [
        (c) => InterceptorsWrapper(),
      ],
      transformerFactory: (c) => BackgroundTransformer(),
      httpClientAdapterFactory: (c) => HttpClientAdapter(),
    ),
  ],
);

Future<void> main() => runner.run();
