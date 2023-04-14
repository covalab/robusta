Robusta Dio
===========

Robusta extension for integrating Dio features.


Installation
------------

Install this package via pub command:

```
dart pub add robusta_dio
```

Usages
------

```dart
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
```

