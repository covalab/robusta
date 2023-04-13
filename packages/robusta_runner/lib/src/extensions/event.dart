part of '../extensions.dart';

/// Uses to add/define event listeners to [EventManager] given.
typedef EventConfigurator = FutureOr<void> Function(
  EventManager,
  ProviderContainer,
);

/// {@template runner.event_extension}
/// Event extension support adding system events,
/// set event manager for provider instance to aware it.
/// {@endtemplate}
@sealed
class EventExtension implements Extension {
  /// {@macro runner.event_extension}
  EventExtension({required EventConfigurator configurator})
      : _eventConfigurator = configurator;

  final EventConfigurator _eventConfigurator;

  @override
  void load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 8192);
  }

  Future<void> _boot(ProviderContainer c) async {
    return _eventConfigurator(c.read(eventManagerProvider), c);
  }
}
