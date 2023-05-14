import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/src/sub_commands/generate_repository.dart';
import 'package:flutter_robusta_cli/src/sub_commands/generate_screen.dart';
import 'package:logger/logger.dart';

/// {@template generate_command}
/// Support code generation
/// {@endtemplate}
class GenerateCommand extends Command<int> {
  /// {@macro generate_command}
  GenerateCommand({required Logger logger}) : _logger = logger {
    addSubcommand(GenerateRepositoryCommand(logger: _logger));
    addSubcommand(GenerateScreenCommand(logger: _logger));
  }

  final Logger _logger;

  @override
  String get description => 'Support to generate boilerplate code';

  @override
  String get name => 'generate';

  @override
  List<String> get aliases => ['gen', 'g'];

  @override
  String get invocation => 'robusta gen [generator] [options]';
}
