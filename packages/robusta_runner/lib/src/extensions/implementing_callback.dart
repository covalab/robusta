// ignore_for_file: one_member_abstracts
part of '../extensions.dart';

/// Callback function will be call when instances of Riverpod providers
/// implementing [T] type.
typedef ImplementingCallback<T> = void Function(T, ProviderContainer);

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

/// An extension providing implementing callback feature for runner providers.
@sealed
class ImplementingCallbackExtension implements Extension {
  late final _observer = _ImplementingCallbackObserver(
    [
      _ImplementingCallbackResolver<EventManagerAware>(
        (instance, container) => instance.setEventManager(
          container.read(eventManagerProvider),
        ),
      ),
      _ImplementingCallbackResolver<LoggerAware>(
        (instance, container) => instance.setLogger(
          container.read(loggerProvider),
        ),
      ),
    ],
  );

  @override
  void load(Configurator configurator) {
    configurator.addContainerObserver(_observer);
  }

  /// Register implementing callback
  void addImplementingCallback<T>(ImplementingCallback<T> callback) {
    _observer.addImplementingCallback<T>(callback);
  }
}

/// Riverpod observer for adding implementing callback feature.
/// When instance of provider will provide created, and it implement
/// class/interface had registered callback before, a callback will be call.
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
