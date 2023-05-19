---
id: robusta-dio
title: Robusta Dio
sidebar_position: 4
---

### Prerequites 📝

### Installing ⚙️

### Usage

```js
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

### API
