import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/src/flutter.dart';
import 'package:flutter_robusta_cli/src/utils.dart';
import 'package:interact/interact.dart';
import 'package:logger/logger.dart';

/// {@template init_command}
/// Init command will add Robusta dependencies and generate structure
/// for existing projects.
/// {@endtemplate}
class InitCommand extends Command<int> {
  /// {@macro init_command}
  InitCommand({required FlutterBin flutterBin, required Logger logger})
      : _flutterBin = flutterBin,
        _logger = logger;

  final FlutterBin _flutterBin;

  final Logger _logger;

  @override
  String get description => 'Init skeleton for existing project';

  @override
  String get name => 'init';

  @override
  String get invocation => 'robusta init';

  @override
  Future<int>? run() async {
    final confirm = Confirm(
      prompt: '''
This command may overwrite existing files, do you want to continue?
      ''',
    ).interact();

    if (!confirm) {
      _logger.i('Cancelled!');

      return 0;
    }

    await _flutterBin.ensureFlutterInstalled();
    await _flutterBin.addPubDependencies(
      dependencies: [
        'logger',
        'flutter_riverpod',
        'flutter_robusta',
        'go_router_plus'
      ],
      workingDirectory: Directory.current,
    );
    await generateBrickNewProject(
      packageName: _packageName,
      workingDirectory: Directory.current,
      runHook: false,
    );

    _logger.i('Init skeleton successful!');

    return 0;
  }

  String get _packageName {
    try {
      return describePubspec('${Directory.current.path}/pubspec.yaml').name;
    } on Exception {
      usageException('Not found pubspec.yaml');
    }
  }
}
