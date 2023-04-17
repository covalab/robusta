import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_new_project_bundle.dart';
import 'package:interact/interact.dart' as interact;
import 'package:logger/logger.dart';
import 'package:mason/mason.dart' as mason;
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
    try {
      await _ensureFlutterInstalled();
      await _createFlutterProject();
      await _generateSkeleton();
      await _addRobustaDependencies();

      _logger.i('Create new Flutter project: $_projectName successful!');
    } on Exception catch (e, s) {
      interact.reset();
      _deleteFlutterProject();
      rethrow;
    }

    return 0;
  }

  Future<void> _ensureFlutterInstalled() async {
    final loading = _getSpinner(
      onLoadMessage: 'Checking Flutter bin exist',
      completedMessage: 'Checking Flutter bin exist',
    ).interact();

    final result = await _processRunnable('flutter', args: ['--version']);

    if (0 != result) {
      usageException(
        'To uses this command, you MUST be install Flutter first.',
      );
    }

    loading.done();
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

  Future<void> _createFlutterProject() async {
    final loading = _getSpinner(
      onLoadMessage: 'Creating Flutter project',
      completedMessage: 'Creating Flutter project',
    ).interact();

    final result = await _processRunnable(
      'flutter',
      args: [
        'create',
        _projectName,
        '--project-name=$_projectName',
        '--org=$_org',
      ],
    );

    if (0 != result) {
      throw Exception('Can not create Flutter project');
    }

    loading.done();
  }

  Future<void> _addRobustaDependencies() async {
    final loading = _getSpinner(
      onLoadMessage: 'Adding Robusta dependencies',
      completedMessage: 'Adding Robusta dependencies',
    ).interact();
    final pub = PubUpdater();
    final versions = await Future.wait([
      pub.getLatestVersion('logger'),
      pub.getLatestVersion('flutter_riverpod'),
      pub.getLatestVersion('flutter_robusta'),
      pub.getLatestVersion('go_router_plus'),
    ]);
    final result = await _processRunnable(
      'flutter',
      args: [
        'pub',
        'add',
        'logger:^${versions[0]}',
        'flutter_riverpod:^${versions[1]}',
        'flutter_robusta:^${versions[2]}',
        'go_router_plus:^${versions[3]}',
      ],
      workingDirectory: _projectDirectory.path,
    );

    if (0 != result) {
      throw Exception('Can not add Robusta dependencies.');
    }

    loading.done();
  }

  Future<void> _generateSkeleton() async {
    final loading = _getSpinner(
      onLoadMessage: 'Generating skeleton',
      completedMessage: 'Generating skeleton',
    ).interact();

    Directory('${_projectDirectory.path}/lib').deleteSync(recursive: true);
    Directory('${_projectDirectory.path}/test').deleteSync(recursive: true);

    final generator = await mason.MasonGenerator.fromBundle(
      robustaNewProjectBundle,
    );

    await generator.generate(
      mason.DirectoryGeneratorTarget(_projectDirectory),
      vars: {
        'project_name': _projectName,
      },
      fileConflictResolution: mason.FileConflictResolution.overwrite,
    );

    loading.done();
  }

  void _deleteFlutterProject() => _projectDirectory.deleteSync(recursive: true);

  interact.Spinner _getSpinner({
    required String onLoadMessage,
    required String completedMessage,
  }) {
    return interact.Spinner(
      icon: '\u{2714}',
      rightPrompt: (done) => done ? onLoadMessage : completedMessage,
    );
  }
}
