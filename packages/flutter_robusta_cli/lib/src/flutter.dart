import 'dart:async';
import 'dart:io';

import 'package:flutter_robusta_cli/src/process.dart';
import 'package:flutter_robusta_cli/src/utils.dart';
import 'package:logger/logger.dart';
import 'package:pub_updater/pub_updater.dart';

/// {@template utils.flutter_cli}
/// Help to run Flutter bin
/// {@endtemplate}
class FlutterBin {
  /// {@macro utils.flutter_cli}
  FlutterBin({
    required Logger logger,
    ProcessRunnable processRunner = nativeRunCommand,
  })  : _processRunner = processRunner,
        _logger = logger;

  final ProcessRunnable _processRunner;

  final Logger _logger;

  /// Create new project with [projectName] and [org] given.
  Future<void> createProject(
    String projectName,
    String org,
    Directory workingDirectory,
  ) async {
    final loading = makeSpinner(
      onLoadMessage: 'Creating Flutter project',
      completedMessage: 'Creating Flutter project',
    ).interact();

    final result = await _run(
      [
        'create',
        projectName,
        '--project-name=$projectName',
        '--org=$org',
      ],
      workingDirectory,
    );

    if (0 != result) {
      throw Exception('Can not create Flutter project');
    }

    loading.done();
  }

  FutureOr<int> _run(List<String> args, Directory workingDirectory) {
    return _processRunner(
      'flutter',
      args: args,
      logger: _logger,
      workingDirectory: workingDirectory,
    );
  }

  /// Helps to add pub dependencies
  Future<void> addPubDependencies({
    required List<String> dependencies,
    required Directory workingDirectory,
  }) async {
    final loading = makeSpinner(
      onLoadMessage: 'Adding Pub dependencies',
      completedMessage: 'Adding Pub dependencies',
    ).interact();
    final pub = PubUpdater();
    final latestVersions = Map.fromIterables(
      dependencies,
      await Future.wait(dependencies.map(pub.getLatestVersion)),
    );

    final versionConstraints = latestVersions.entries.toList().map(
          (e) => '${e.key}:^${e.value}',
        );

    final result = await _run(
      ['pub', 'add', ...versionConstraints],
      workingDirectory,
    );

    if (0 != result) {
      throw Exception('Can not add Pub dependencies.');
    }

    loading.done();
  }

  /// Ensure Flutter had installed
  Future<void> ensureFlutterInstalled() async {
    final loading = makeSpinner(
      onLoadMessage: 'Checking Flutter bin exist',
      completedMessage: 'Checking Flutter bin exist',
    ).interact();

    final result = await _run(['--version'], Directory.current);

    if (0 != result) {
      throw Exception('You MUST be install Flutter first.');
    }

    loading.done();
  }
}
