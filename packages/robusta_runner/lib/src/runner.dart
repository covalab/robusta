// ignore_for_file: implicit_call_tearoffs
import 'dart:async';

import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';
import 'package:robusta_events/robusta_events.dart';
import 'package:robusta_runner/src/provider.dart';

part 'runner/container.dart';

part 'runner/event.dart';

part 'runner/exception.dart';

part 'runner/extension.dart';

/// Bootable type.
typedef Bootable = FutureOr<void> Function(ProviderContainer);

/// Runner class creates an instance to run your application,
/// with this runner your app will be easy to scale, extend and maintain.
@sealed
class Runner {
  /// Runner factory
  Runner({
    Map<Bootable, int>? boots,
    EventManager? eventManager,
    Logger? logger,
    List<Extension> extensions = const [],
    ContainerOptions? containerOptions,
  })  : _boots = boots ?? {},
        _logger = logger ?? Logger(),
        _containerOptions = containerOptions ?? ContainerOptions() {
    _eventManager = eventManager ?? DefaultEventManager(logger: _logger);
    _initExtensions(extensions);
  }

  late final _container = ProviderContainer(
    overrides: [
      ..._containerOptions._overrides,
      loggerProvider.overrideWithValue(_logger),
      eventManagerProvider.overrideWithValue(_eventManager),
    ],
    observers: _containerOptions._observers,
  );

  final ContainerOptions _containerOptions;

  late final EventManager _eventManager;

  final Logger _logger;

  final Map<Bootable, int> _boots;

  late final Map<Type, Extension> _extensions;

  /// Stores incoming list of extensions
  /// Notice that each extension should be unquie
  /// If the same extensions are initalized
  /// an exception will be thrown - duplicateExtension
  void _initExtensions(List<Extension> extensions) {
    _extensions = {};

    for (final extension in extensions) {
      if (_extensions.containsKey(extension.runtimeType)) {
        throw RunnerException.duplicateExtension(extension.runtimeType);
      }

      _extensions[extension.runtimeType] = extension;
    }

    for (final extension in extensions) {
      if (extension is! DependenceExtension) {
        continue;
      }

      if (!extension.dependsOn().every(_extensions.containsKey)) {
        throw RunnerException.missingExtensionDependencies(extension);
      }
    }
  }

  /// Run your application.
  /// This should be your app starting point
  Future<void> run() async => runZonedGuarded(_rawRun, _errorHandle);

  /// This function will reposnsible for booting up any
  /// services/utils/extensions,...
  /// before your application runs.
  Future<void> _rawRun() async {
    await _boot();

    _logger.d('Running...');

    await _eventManager.dispatchEvent(RunEvent(container: _container));
  }

  bool _booted = false;

  Future<void> _boot() async {
    if (_booted) {
      return;
    }

    _booted = true;

    _logger.d('Loading extensions...');

    await _loadExtensions();

    _logger.d('Booting...');

    for (final boot in _sortedBoots) {
      await boot(_container);
    }
  }

  /// This function is in charge of running any given extensions
  Future<void> _loadExtensions() async {
    final configurator = Configurator._(this);

    await Future.wait(
      _extensions.entries.map(
        (e) async {
          await e.value.load(configurator);
          _logger.d('Extension: ${e.value.runtimeType} loaded.');
        },
      ),
    );
  }

  /// Sorts all bootable [Services or Utils] by
  /// their priority - From highest to lowest
  /// Bootables are which needed to be run before your application runs.
  Iterable<Bootable> get _sortedBoots {
    final entries = _boots.entries.toList()
      ..sort(
        (e1, e2) => e2.value.compareTo(e1.value),
      );

    return entries.map((e) => e.key);
  }

  Future<void> _errorHandle(Object error, StackTrace stackTrace) async {
    _logger.e('Run error...', error, stackTrace);

    await _eventManager.dispatchEvent(
      ExceptionEvent(
        error: error,
        stackTrace: stackTrace,
        container: _container,
      ),
    );
  }
}
