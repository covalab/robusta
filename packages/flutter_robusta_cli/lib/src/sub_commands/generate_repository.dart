import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_gen_repo_bundle.dart';
import 'package:flutter_robusta_cli/src/utils.dart';
import 'package:interact/interact.dart';
import 'package:logger/logger.dart';

/// {@template sub_commands.generate_repository_command}
/// Helps to generate repository
/// {@endtemplate}
class GenerateRepositoryCommand extends Command<int> {
  /// {@macro sub_commands.generate_repository_command}
  GenerateRepositoryCommand({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  String get description => 'Generate repository based on GraphQL or Dio';

  @override
  String get name => 'repository';

  @override
  List<String> get aliases => ['repo', 'r'];

  @override
  String get invocation => 'robusta generate repository [name]';

  @override
  Future<int>? run() async {
    final repo = _repoName;
    final choice = Select(
      prompt: 'Which api client do you want to use?',
      options: [
        'dio',
        'graphql',
      ],
    ).interact();
    final useDio = choice == 0;

    await generateBricks(
      bundles: [robustaGenRepoBundle],
      workingDirectory: Directory.current,
      vars: {
        'use_dio': useDio,
        'name': repo,
      },
    );

    _logger.i('Generate repository successful!');

    return 0;
  }

  String get _repoName {
    final args = argResults!.rest;

    if (args.isEmpty) {
      usageException('No option specified for the repository name.');
    }

    return args.first;
  }
}
