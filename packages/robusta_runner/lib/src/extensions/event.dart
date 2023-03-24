part of '../extensions.dart';

/// {@template runner.event_extension}
/// Event extension support adding system events,
/// set event manager for provider instance to aware it.
/// {@endtemplate}
@sealed
class EventExtension<E extends Event> implements Extension {
  /// {@macro runner.event_extension}
  EventExtension(this._listeners);

  final Map<EventListener<E>, int> _listeners;

  @override
  void load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 8192);
  }

  void _boot(ProviderContainer c) {
    final em = c.read(eventManagerProvider);

    for (final entry in _listeners.entries) {
      em.addEventListener<E>(entry.key, priority: entry.value);
    }
  }
}
