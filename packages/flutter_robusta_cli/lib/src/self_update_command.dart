import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/version.g.dart';
import 'package:interact/interact.dart';
import 'package:logger/logger.dart';
import 'package:pub_updater/pub_updater.dart';

/// {@template self_update_command}
/// Command help to update Robusta CLI itself.
/// {@endtemplate}
class SelfUpdateCommand extends Command<int> {
  /// {@macro self_update_command}
  SelfUpdateCommand({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  String get description => 'Uses to check and update Robusta CLI itself.';

  @override
  String get name => 'self-update';

  @override
  String get invocation => 'robusta self-update';

  @override
  Future<int> run() async {
    final pub = PubUpdater();
    final isUpToDate = await pub.isUpToDate(
      packageName: 'flutter_robusta_cli',
      currentVersion: cliVersion,
    );

    if (isUpToDate) {
      _logger.i('Your Robusta CLI is up-to-date.');

      return 0;
    }

    final latestVersion = await pub.getLatestVersion('flutter_robusta_cli');
    final answer = Confirm(
      prompt: '''
Current version is $latestVersion - your local version is $cliVersion, 
do you want to update it to $latestVersion?,
        ''',
      defaultValue: true,
    ).interact();

    if (answer) {
      await pub.update(packageName: 'flutter_robusta_cli');
      _logger.i('Your CLI already up-to-date.');
    } else {
      _logger.i('Self update cancelled.');
    }

    return 0;
  }
}
