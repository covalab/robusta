import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_gen_screen_bundle.dart';
import 'package:flutter_robusta_cli/src/utils.dart';
import 'package:interact/interact.dart';
import 'package:logger/logger.dart';

/// {@template sub_commands.generate_repository_command}
/// Helps to generate repository
/// {@endtemplate}
class GenerateScreenCommand extends Command<int> {
  /// {@macro sub_commands.generate_repository_command}
  GenerateScreenCommand({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  String get description => 'Generate shell screen or normal screen.';

  @override
  String get name => 'screen';

  @override
  List<String> get aliases => ['s'];

  @override
  String get invocation => 'robusta generate screen [name]';

  @override
  Future<int>? run() async {
    final screenName = _screenName;
    final choice = Select(
      prompt: 'Which type of screen do you want to use?',
      options: [
        'normal',
        'shell',
      ],
    ).interact();
    final useShell = choice == 1;

    await generateBricks(
      bundles: [robustaGenScreenBundle],
      workingDirectory: Directory.current,
      vars: {
        'use_shell': useShell,
        'name': screenName,
      },
    );

    _logger.i('Generate screen successful!');

    return 0;
  }

  String get _screenName {
    final args = argResults!.rest;

    if (args.isEmpty) {
      usageException('No option specified for the screen name.');
    }

    return args.first;
  }
}
