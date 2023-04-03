import 'dart:async';

/// Event is the base class for classes containing event data.
abstract class Event {
  bool _propagationStopped = false;

  /// Stops the propagation of the event to further event listeners.
  /// If multiple event listeners are connected to the same event, no
  /// further event listener will be triggered once any events call
  /// stopPropagation().
  void stopPropagation() {
    _propagationStopped = true;
  }

  /// Whether the propagation stopped or not.
  bool get isPropagationStopped => _propagationStopped;
}

/// A callable will be call when <E> event dispatched.
typedef EventListener<E extends Event> = FutureOr<void> Function(E);

/// Store [EventListener] and its priority of events type [E].
class EventStore<E extends Event> {
  final _listeners = <EventListener<E>, int>{};

  /// Add [EventListener] of event [E].
  void addEventListener(EventListener<E> listener, {int priority = 0}) {
    _listeners[listener] = priority;
  }

  /// [EventListener] iterable of event [E] had add before.
  Iterable<EventListener<E>> get eventListeners {
    final entries = _listeners.entries.toList()
      ..sort(
        (e1, e2) => e2.value.compareTo(e1.value),
      );

    return entries.map((e) => e.key);
  }

  /// Remove registered [EventListener]
  void removeEventListener(EventListener<E> listener) {
    _listeners.remove(listener);
  }
}
