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

/// Bootable type, will be call when call [Runner.run],
/// it only run exact one time.
typedef Bootable = FutureOr<void> Function(ProviderContainer);

/// Define boot will be run with priority given uses to ordering boots,
/// higher priority will be run first.
typedef BootDefinition = void Function(Bootable, {int priority});

/// Callback function uses to define boots via [BootDefinition].
typedef DefineBoot = void Function(BootDefinition);

/// Callback function uses to define extension function via [ExtensionFactory]
typedef ExtensionFactory = FutureOr<Extension> Function();

/// Runner class creates an instance to run your application,
/// with this runner your app will be easy to scale, extend and maintain.
@sealed
class Runner {
  /// Runner factory
  Runner({
    DefineBoot? defineBoot,
    EventManager? eventManager,
    Logger? logger,
    List<ExtensionFactory> extensions = const [],
    ContainerOptions? containerOptions,
  })  : _logger = logger ?? Logger(),
        _containerOptions = containerOptions ?? ContainerOptions(),
        _listExtension = extensions {
    _eventManager = eventManager ?? DefaultEventManager(logger: _logger);

    if (null != defineBoot) {
      defineBoot(
        (bootable, {int priority = 0}) => _boots[bootable] = priority,
      );
    }
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

  final Map<Bootable, int> _boots = {};

  late final Map<Type, Extension> _extensions;

  final List<ExtensionFactory> _listExtension;

  /// Stores incoming list of extensions
  /// Notice that each extension should be unquie
  /// If the same extensions are initalized
  /// an exception will be thrown - duplicateExtension
  Future<void> _initExtensions(List<ExtensionFactory> factories) async {
    _extensions = {};

    final extensions = <Extension>[];

    // Create array which calls all the factory element in extension
    // This will start initing all the properties passed through extension
    // constructor
    for (final factory in factories) {
      final f = await factory();
      extensions.add(f);
    }

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

  Future<void> run() {
    final completer = Completer<void>();

    runZonedGuarded(() async {
      try {
        await _rawRun();
        completer.complete();
      } catch (exception, stack) {
        completer.completeError(exception, stack);

        rethrow;
      }
    }, (error, stack) async {
      await _errorHandle(error, stack);
    });

    return completer.future;
  }

  /// This function will reposnsible for booting up any
  /// services/utils/extensions,...
  /// before your application runs.
  Future<void> _rawRun() async {
    await _initExtensions(_listExtension);

    await _boot();

    _logger.d('Running...');

    await _eventManager.dispatchEvent(
      RunEvent._(
        container: _container,
        zone: Zone.current,
      ),
    );
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
      ErrorEvent._(
        error: error,
        stackTrace: stackTrace,
        container: _container,
      ),
    );
  }
}
