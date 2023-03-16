// ignore_for_file: one_member_abstracts
part of '../extensions.dart';

/// Callback function will be call when instances of Riverpod providers
/// implementing [E] type.
typedef ImplementingCallback<E> = void Function(E, ProviderContainer);

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
    callbacks: [
      _ImplementingCallback<EventManagerAware>((instance, container) {
        instance.setEventManager(container.read(eventManagerProvider));
      }),
      _ImplementingCallback<LoggerAware>((instance, container) {
        instance.setLogger(container.read(loggerProvider));
      }),
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
  _ImplementingCallbackObserver({
    List<_ImplementingCallback<dynamic>>? callbacks,
  }) : _callbacks = [...callbacks ?? []];

  final List<_ImplementingCallback<dynamic>> _callbacks;

  @override
  void didAddProvider(
    ProviderBase<dynamic> provider,
    Object? value,
    ProviderContainer container,
  ) {
    for (final callback in _callbacks) {
      callback(value, container);
    }
  }

  void addImplementingCallback<E>(ImplementingCallback<E> item) {
    _callbacks.add(_ImplementingCallback<E>(item));
  }
}

class _ImplementingCallback<E> {
  _ImplementingCallback(this._callback);

  final ImplementingCallback<E> _callback;

  void call(dynamic value, ProviderContainer container) {
    if (value is E) {
      _callback(value, container);
    }
  }
}
