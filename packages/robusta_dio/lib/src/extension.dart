import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:robusta_dio/src/dio.dart';
import 'package:robusta_dio/src/provider.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// Callback function uses to create [Interceptor] with [ProviderContainer]
/// given.
typedef InterceptorFactory = Interceptor Function(ProviderContainer);

/// Callback function uses to create [Transformer] with [ProviderContainer]
/// given.
typedef TransformerFactory = Transformer Function(ProviderContainer);

/// Callback function uses to create [HttpClientAdapter]
/// with [ProviderContainer] given.
typedef HttpClientAdapterFactory = HttpClientAdapter Function(
  ProviderContainer,
);

/// {@template dio_extension}
/// An extension for integrating Dio features to [Runner].
/// {@endtemplate}
class DioExtension implements Extension {
  /// {@macro dio_extension}
  DioExtension({
    BaseOptions? baseOptions,
    HttpClientAdapterFactory? httpClientAdapterFactory,
    TransformerFactory? transformerFactory,
    List<InterceptorFactory>? interceptorFactories,
  })  : _baseOptions = baseOptions,
        _httpClientAdapterFactory = httpClientAdapterFactory,
        _transformerFactory = transformerFactory,
        _interceptorFactories = [...?interceptorFactories];

  final BaseOptions? _baseOptions;

  final HttpClientAdapterFactory? _httpClientAdapterFactory;

  final TransformerFactory? _transformerFactory;

  final List<InterceptorFactory> _interceptorFactories;

  @override
  FutureOr<void> load(Configurator configurator) {
    configurator.addContainerOverride(_dioOverride());

    if (configurator.hasExtension<ImplementingCallbackExtension>()) {
      configurator.defineImplementingCallback<DioAware>(
        (instance, container) => instance.setDio(
          container.read(dioProvider),
        ),
      );
    }
  }

  Override _dioOverride() {
    return dioProvider.overrideWith((ref) {
      final dio = Dio(_baseOptions);

      for (final factory in _interceptorFactories) {
        dio.interceptors.add(factory(ref.container));
      }

      if (null != _transformerFactory) {
        dio.transformer = _transformerFactory!(ref.container);
      }

      if (null != _httpClientAdapterFactory) {
        dio.httpClientAdapter = _httpClientAdapterFactory!(ref.container);
      }

      return dio;
    });
  }
}
