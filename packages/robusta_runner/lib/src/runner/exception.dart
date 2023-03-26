part of '../runner.dart';

/// Collects exceptions throw by [Runner].
@sealed
class RunnerException implements Exception {
  RunnerException._(this._msg);

  /// Throw in case user added duplicate extensions.
  factory RunnerException.duplicateExtension(Type e) =>
      RunnerException._('Duplicate extension $e');

  /// Throw in case user gets extension but it not exist.
  factory RunnerException.extensionNotExist(Type e) => RunnerException._(
        'Extension $e not exist, do you forget to add it to runner extensions?',
      );

  /// Throw in case user forgot to add dependencies of extension.
  factory RunnerException.missingExtensionDependencies(DependenceExtension e) =>
      RunnerException._(
        'Extension $e depends on ${e.dependsOn()}, do you forgot to add them?',
      );

  final String _msg;

  @override
  String toString() => _msg;
}
