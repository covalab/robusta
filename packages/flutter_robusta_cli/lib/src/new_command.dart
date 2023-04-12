import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:logger/logger.dart';
import 'package:pub_updater/pub_updater.dart';

/// Uses to run process
typedef ProcessRunnable = FutureOr<int> Function(
  String, {
  required List<String> args,
  String? workingDirectory,
});

/// {@template new_command}
/// Command for creating new Flutter project
/// {@endtemplate}
class NewCommand extends Command<int> {
  /// {@macro new_command}
  NewCommand({
    required Logger logger,
    ProcessRunnable? processRunnable,
  }) : _logger = logger {
    if (null != processRunnable) {
      _processRunnable = processRunnable;
    } else {
      _processRunnable = (
        String cmd, {
        required List<String> args,
        String? workingDirectory,
      }) async {
        final result = await Process.run(
          cmd,
          args,
          workingDirectory: workingDirectory,
        );

        if (null != result.stdout && result.exitCode != 0) {
          logger.e('[Flutter] ${result.stdout}');
        }

        if (null != result.stderr && result.exitCode != 0) {
          logger.e('[Flutter] ${result.stderr}');
        }

        return result.exitCode;
      };
    }

    argParser.addOption(
      'org',
      defaultsTo: 'com.example',
      help: '''
The organization responsible for your new Flutter project, in reverse domain 
name notation. This string is used in Java package names and as prefix in the 
iOS bundle identifier.
    ''',
    );
  }

  final Logger _logger;

  late final ProcessRunnable _processRunnable;

  @override
  String get description => 'Create new Flutter project uses Robusta';

  @override
  String get name => 'new';

  @override
  String get invocation => '''
robusta new <project-name> [args]
<project-name> must be valid Flutter package name (snake_case).
  ''';

  @override
  Future<int> run() async {
    await _ensureFlutterInstalled();

    try {
      if (!await _createFlutterProject()) {
        _logger.e('Can not create Flutter project, something went wrong');
        return 1;
      }

      await _addRobustaDependencies();

      _logger.i('Create project: $_projectName successful!');
    } on Exception catch (e, s) {
      _deleteFlutterProject();

      _logger.e('Fail to create project!', e, s);
    }

    return 0;
  }

  Future<void> _ensureFlutterInstalled() async {
    final result = await _processRunnable('flutter', args: ['--version']);

    if (0 != result) {
      usageException(
        'To uses this command, you MUST be install Flutter first.',
      );
    }
  }

  String get _projectName {
    final args = argResults!.rest;

    if (args.isEmpty) {
      usageException('No option specified for the project name.');
    }

    return args.first;
  }

  Directory get _projectDirectory =>
      Directory('${Directory.current.path}/$_projectName');

  String get _org => argResults!['org'] as String;

  Future<bool> _createFlutterProject() async {
    final result = await _processRunnable(
      'flutter',
      args: [
        'create',
        _projectName,
        '--project-name=$_projectName',
        '--org=$_org',
      ],
    );

    return 0 == result;
  }

  Future<bool> _addRobustaDependencies() async {
    final pub = PubUpdater();
    final versions = await Future.wait([
      pub.getLatestVersion('logger'),
      pub.getLatestVersion('flutter_riverpod'),
      pub.getLatestVersion('flutter_robusta'),
      pub.getLatestVersion('flutter_robusta_auth'),
      pub.getLatestVersion('flutter_robusta_hive'),
      pub.getLatestVersion('flutter_robusta_hive_auth'),
    ]);
    final result = await _processRunnable(
      'flutter',
      args: [
        'pub',
        'add',
        'logger:^${versions[0]}',
        'flutter_riverpod:^${versions[1]}',
        'flutter_robusta:^${versions[2]}',
        'flutter_robusta_auth:^${versions[3]}',
        'flutter_robusta_hive:^${versions[4]}',
        'flutter_robusta_hive_auth:^${versions[5]}',
      ],
      workingDirectory: _projectDirectory.path,
    );

    return 0 == result;
  }

  void _deleteFlutterProject() => _projectDirectory.deleteSync(recursive: true);
}
