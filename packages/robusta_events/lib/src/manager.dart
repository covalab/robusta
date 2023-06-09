// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:logger/logger.dart';
import 'package:robusta_events/src/event.dart';

/// Event manager interface
/// Implements by classes help to manage events.
abstract class EventManager {
  /// Add event listener, it will be trigger when event dispatched.
  void addEventListener<E extends Event>(
    EventListener<E> listener, {
    int priority = 0,
  });

  /// Remove registered event listener
  void removeEventListener<E extends Event>(EventListener<E> listener);

  /// Dispatch given events.
  FutureOr<void> dispatchEvent<E extends Event>(E event);
}

/// {@template: event_manager.default_event_manager}
/// Default event manager implementing [EventManager].
/// {@endtemplate}
class DefaultEventManager implements EventManager {
  /// {@macro: event_manager.default_event_manager}
  DefaultEventManager({Logger? logger}) : _logger = logger;

  final Logger? _logger;

  final Map<Type, EventStore<Event>> _stores = {};

  /// Get [EventStore] by [Event] type.
  EventStore<E> _getEventStore<E extends Event>() {
    final store = _stores[E];

    if (null != store && store.runtimeType == EventStore<E>) {
      return store as EventStore<E>;
    } else {
      return _stores[E] = EventStore<E>();
    }
  }

  @override
  void addEventListener<E extends Event>(
    EventListener<E> listener, {
    int priority = 0,
  }) =>
      _getEventStore<E>().addEventListener(listener, priority: priority);

  @override
  void removeEventListener<E extends Event>(EventListener<E> listener) =>
      _getEventStore<E>().removeEventListener(listener);

  @override
  FutureOr<void> dispatchEvent<E extends Event>(E event) async {
    final listeners = _getEventStore<E>().eventListeners;

    _logger?.d('Dispatching event: $E to ${listeners.length} listener(s)...');

    for (final callable in listeners) {
      if (event.isPropagationStopped) {
        _logger?.d('Event $E propagation stopped.');

        break;
      }

      await callable(event);
    }
  }
}
