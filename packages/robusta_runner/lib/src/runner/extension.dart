// ignore_for_file: one_member_abstracts
part of '../runner.dart';

/// Support to settings runner
@sealed
class Configurator {
  Configurator._(this._runner);

  final Runner _runner;

  /// Add boot to runner
  void addBoot(Bootable bootable, {int priority = 0}) {
    _runner._boots[bootable] = priority;
  }

  /// Add observer to runner container
  void addContainerObserver(ProviderObserver observer) {
    _runner._containerOptions._observers.add(observer);
  }

  /// Add override to runner container
  void addContainerOverride(Override override) =>
      _runner._containerOptions._overrides.add(override);

  /// Get an extension [T] of runner
  /// An exception will be throw in case [T] not exist.
  T getExtension<T extends Extension>() {
    if (!_runner._extensions.containsKey(T)) {
      throw RunnerException.extensionNotExist(T);
    }

    return _runner._extensions[T]! as T;
  }

  /// Checking runner has extension [T] or not.
  bool hasExtension<T extends Extension>() {
    return _runner._extensions.containsKey(T);
  }
}

/// Extension interface for extensible, implementing classes will extend runner
/// by adding features to it like boots, container overrides,
/// container observers.
abstract class Extension {
  /// Load extension features to runner via configurator.
  @visibleForOverriding
  FutureOr<void> load(Configurator configurator);
}

/// {@template dependence}
/// An interface represent for extensions need specific extensions to load.
/// {@endtemplate}
abstract class DependenceExtension extends Extension {
  /// List extensions [Type] depends on.
  @visibleForOverriding
  List<Type> dependsOn();
}
