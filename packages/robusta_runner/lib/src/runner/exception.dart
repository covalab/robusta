part of '../runner.dart';

/// Collects exceptions throw by [Runner].
@sealed
class RunnerException implements Exception {
  RunnerException._(this._msg);

  /// Throw in case user add duplicate extensions.
  factory RunnerException.duplicateExtension(Type e) =>
      RunnerException._('Duplicate extension $e');

  /// Throw in case user get extension but it not exist.
  factory RunnerException.extensionNotExist(Type e) => RunnerException._(
        'Extension $e not exist, do you forget to add it to runner extensions?',
      );

  final String _msg;

  @override
  String toString() => _msg;
}
