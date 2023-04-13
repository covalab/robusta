part of '../runner.dart';

/// Event base class of [Runner]
class _RunnerEvent extends Event {
  _RunnerEvent({required this.container});

  /// [Runner] container use for exploring providers.
  final ProviderContainer container;
}

/// {@template runner.run_event}
/// Will dispatch when [Runner.run()] called,
/// this event will be dispatched after boot.
/// {@endtemplate}
class RunEvent extends _RunnerEvent {
  /// {@macro runner.run_event}
  RunEvent._({required super.container, required this.zone});

  /// Running zone
  final Zone zone;
}

/// {@template runner.exception_event}
/// Will dispatch when [Runner.run()] throw exceptions.
/// {@endtemplate}
class ErrorEvent extends _RunnerEvent {
  /// {@macro runner.exception_event}
  ErrorEvent._({
    required super.container,
    required this.error,
    required this.stackTrace,
  });

  /// An error/exception had been throw.
  final Object error;

  /// Exception stack trace.
  final StackTrace stackTrace;
}
