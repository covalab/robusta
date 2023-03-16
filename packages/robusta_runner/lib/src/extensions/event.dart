part of '../extensions.dart';

/// {@template runner.event_extension}
/// Event extension support to add system events,
/// set event manager for provider instance aware it.
/// {@endtemplate}
@sealed
class EventExtension<E extends Event> implements Extension {
  /// {@macro runner.event_extension}
  EventExtension({
    Map<EventListener<E>, int>? listeners,
  }) : _listeners = {...listeners ?? {}};

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
