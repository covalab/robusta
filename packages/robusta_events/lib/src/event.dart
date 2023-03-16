import 'dart:async';

/// Event is the base class for classes containing event data.
abstract class Event {
  bool _propagationStopped = false;

  /// Stops the propagation of the event to further event listeners.
  /// If multiple event listeners are connected to the same event, no
  /// further event listener will be triggered once any trigger calls
  /// stopPropagation().
  void stopPropagation() {
    _propagationStopped = true;
  }

  /// Whether the propagation stopped or not.
  bool get isPropagationStopped => _propagationStopped;
}

/// A callable will be call when <E> event dispatched.
typedef EventListener<E extends Event> = FutureOr<void> Function(E);

/// Store [EventListener] of events type <E> and trigger all of them
/// when calling method dispatch().
class EventStore<E extends Event> {
  final _listeners = <EventListener<E>, int>{};

  /// Add [EventListener] of event [E].
  void addEventListener(EventListener<E> listener, {int? priority}) {
    _listeners[listener] = priority ?? 0;
  }

  /// [EventListener] iterable of event [E] had add before.
  Iterable<EventListener<E>> get eventListeners {
    final entries = _listeners.entries.toList()
      ..sort(
        (e1, e2) => e2.value.compareTo(e1.value),
      );

    return entries.map((e) => e.key);
  }

  /// Remove [EventListener] had registered before.
  void removeEventListener(EventListener<E> listener) {
    _listeners.remove(listener);
  }
}
