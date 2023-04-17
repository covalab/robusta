import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/src/new_command.dart';
import 'package:flutter_robusta_cli/src/self_update_command.dart';
import 'package:flutter_robusta_cli/src/version_command.dart';
import 'package:riverpod/riverpod.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// Flutter cli extension
class FlutterCliExtension implements Extension {
  /// Handle run event with args given.
  FlutterCliExtension({required this.args});

  @override
  FutureOr<void> load(Configurator configurator) {
    configurator.addBoot(_boot);
  }

  void _boot(ProviderContainer container) {
    container.read(eventManagerProvider)
      ..addEventListener<RunEvent>(_onRun)
      ..addEventListener<ErrorEvent>(_onError);
  }

  /// Cli args
  final List<String> args;

  /// Handle run event.
  Future<void> _onRun(RunEvent event) async {
    final exitCode = await _makeCommandRunner(event.container).run(args);

    await _terminate();

    exit(exitCode ?? -1);
  }

  CommandRunner<int> _makeCommandRunner(ProviderContainer container) {
    final runner = CommandRunner<int>(
      'robusta',
      'Robusta CLI, help to create new project, generate code and more...',
    );
    final logger = container.read(loggerProvider);

    runner
      ..addCommand(NewCommand(logger: logger))
      ..addCommand(SelfUpdateCommand(logger: logger))
      ..addCommand(VersionCommand(logger: logger));

    return runner;
  }

  Future<void> _onError(ErrorEvent event) async {
    await _terminate();
    exit(1);
  }

  Future<void> _terminate() => Future.wait([stdout.close(), stderr.close()]);
}
