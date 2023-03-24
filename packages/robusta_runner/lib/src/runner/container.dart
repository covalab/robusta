part of '../runner.dart';

/// {@template runner.container_options}
/// Riverpod provider container options
/// Use it for sharing and enhancing settings.
/// {@endtemplate}
@sealed
class ContainerOptions {
  /// {@macro runner.container_options}
  ContainerOptions({
    List<Override>? overrides,
    List<ProviderObserver>? observers,
  })  : _overrides = [...overrides ?? []],
        _observers = [...observers ?? []];

  final List<Override> _overrides;

  final List<ProviderObserver> _observers;
}
