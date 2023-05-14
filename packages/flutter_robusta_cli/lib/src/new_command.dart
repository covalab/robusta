import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_new_project_bundle.dart';
import 'package:flutter_robusta_cli/src/flutter.dart';
import 'package:flutter_robusta_cli/src/utils.dart';
import 'package:interact/interact.dart' as interact;
import 'package:logger/logger.dart';

/// {@template new_command}
/// Command for creating new Flutter project
/// {@endtemplate}
class NewCommand extends Command<int> {
  /// {@macro new_command}
  NewCommand({
    required FlutterBin flutterBin,
    required Logger logger,
  })  : _flutterBin = flutterBin,
        _logger = logger {
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

  late final FlutterBin _flutterBin;

  final Logger _logger;

  @override
  String get description => 'Create new Flutter project';

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
      await _flutterBin.ensureFlutterInstalled();
      await _flutterBin.createProject(_projectName, _org, Directory.current);
      await _flutterBin.addPubDependencies(
        dependencies: [
          'logger',
          'flutter_riverpod',
          'flutter_robusta',
          'go_router_plus'
        ],
        workingDirectory: _projectDirectory,
      );
      await generateBricks(
        bundles: [robustaNewProjectBundle],
        vars: {
          'package_name': _projectName,
        },
        workingDirectory: _projectDirectory,
      );

      _logger.i('Create new Flutter project: $_projectName successful!');
    } on Exception {
      interact.reset();
      _deleteFlutterProject();
      rethrow;
    }

    return 0;
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

  void _deleteFlutterProject() => _projectDirectory.deleteSync(recursive: true);
}
