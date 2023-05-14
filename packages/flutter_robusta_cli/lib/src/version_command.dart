import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/version.g.dart';
import 'package:logger/logger.dart';

/// {@template version_command}
/// Command help to show current version of Robusta CLI.
/// {@endtemplate}
class VersionCommand extends Command<int> {
  /// {@macro version_command}
  VersionCommand({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  String get description => 'Check current version of Robusta CLI';

  @override
  String get name => 'version';

  @override
  String get invocation => 'robusta version';

  @override
  int run() {
    _logger.i('Current version of Robusta CLI: $cliVersion');

    return 0;
  }
}
