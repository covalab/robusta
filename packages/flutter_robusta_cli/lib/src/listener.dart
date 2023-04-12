import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/src/new_command.dart';
import 'package:flutter_robusta_cli/src/self_update_command.dart';
import 'package:flutter_robusta_cli/src/version_command.dart';
import 'package:riverpod/riverpod.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// Run listener
class RunListener {
  /// Handle run event with args given.
  RunListener(this.args);

  /// Cli args
  final List<String> args;

  /// Handle run event.
  Future<void> call(RunEvent event) async {
    final exitCode = await _makeCommandRunner(event.container).run(args);

    await Future.wait([stdout.close(), stderr.close()]);

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
}
