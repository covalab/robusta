import 'package:robusta_dio/robusta_dio.dart';

DioExtension dioExtension() {
  return DioExtension(
    baseOptions: BaseOptions(
      baseUrl: const String.fromEnvironment(
        'APP_BASE_URL',
        defaultValue: 'your_up_stream_endpoint',
      ),
    ),
    interceptorFactories: [],
  );
}
