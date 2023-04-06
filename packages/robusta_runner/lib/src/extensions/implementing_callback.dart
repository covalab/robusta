// ignore_for_file: one_member_abstracts
part of '../extensions.dart';

/// Callback function will be call when instances of Riverpod providers
/// implementing [T] type.
typedef ImplementingCallback<T> = void Function(T, ProviderContainer);

/// Helper to help define/add implementing callbacks.
typedef ImplementingCallbackDefinition = void Function(
  void Function<T>(ImplementingCallback<T>),
);

/// An interface implements by classes aware loggable.
abstract class LoggerAware {
  /// Set logger
  void setLogger(Logger logger);
}

/// An interface implements by classes aware event manager.
abstract class EventManagerAware {
  /// Set event manager
  void setEventManager(EventManager manager);
}

/// {@template runner.implementing_callback_extension}
/// An extension providing callback implementation feature for runner providers.
/// {@endtemplate}
@sealed
class ImplementingCallbackExtension implements Extension {
  /// {@macro runner.implementing_callback_extension}
  ImplementingCallbackExtension({
    ImplementingCallbackDefinition? definition,
    bool enabledEventManagerAwareCallback = true,
    bool enabledLoggerAwareCallback = true,
  })  : _definition = definition,
        _enabledEventManagerAwareCallback = enabledEventManagerAwareCallback,
        _enabledLoggerAwareCallback = enabledLoggerAwareCallback;

  final ImplementingCallbackDefinition? _definition;

  final bool _enabledEventManagerAwareCallback;

  final bool _enabledLoggerAwareCallback;

  late final _observer = _ImplementingCallbackObserver(
    [
      if (_enabledEventManagerAwareCallback)
        _ImplementingCallbackResolver<EventManagerAware>(
          (instance, container) => instance.setEventManager(
            container.read(eventManagerProvider),
          ),
        ),
      if (_enabledLoggerAwareCallback)
        _ImplementingCallbackResolver<LoggerAware>(
          (instance, container) => instance.setLogger(
            container.read(loggerProvider),
          ),
        ),
    ],
  );

  @override
  void load(Configurator configurator) {
    if (null != _definition) {
      _definition!(defineCallback);
    }

    configurator.addContainerObserver(_observer);
  }

  /// Register implementing callback
  void defineCallback<T>(ImplementingCallback<T> callback) {
    _observer.addImplementingCallback<T>(callback);
  }
}

/// Dart extension of [Configurator] help to
/// settings [ImplementingCallbackExtension].
extension ImplementingCallbackExtensionConfigurator on Configurator {
  /// Register implementing [T] callback.
  void defineImplementingCallback<T>(ImplementingCallback<T> callback) {
    getExtension<ImplementingCallbackExtension>().defineCallback<T>(callback);
  }
}

/// Riverpod observer observes adding implementing callback feature.
/// When instance of provider created, and its implement
/// class/interface had registered callback before, a callback will be called.
class _ImplementingCallbackObserver extends ProviderObserver {
  _ImplementingCallbackObserver(
    List<_ImplementingCallbackResolver<dynamic>>? resolvers,
  ) : _resolvers = [...resolvers ?? []];

  final List<_ImplementingCallbackResolver<dynamic>> _resolvers;

  @override
  void didAddProvider(
    ProviderBase<dynamic> provider,
    Object? value,
    ProviderContainer container,
  ) {
    for (final resolver in _resolvers) {
      resolver.resolve(value, container);
    }
  }

  void addImplementingCallback<T>(ImplementingCallback<T> callback) {
    _resolvers.add(_ImplementingCallbackResolver<T>(callback));
  }
}

class _ImplementingCallbackResolver<T> {
  _ImplementingCallbackResolver(this._callback);

  final ImplementingCallback<T> _callback;

  void resolve(dynamic value, ProviderContainer container) {
    if (value is T) {
      _callback(value, container);
    }
  }
}
