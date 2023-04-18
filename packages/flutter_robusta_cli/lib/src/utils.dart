import 'dart:async';
import 'dart:io';

import 'package:flutter_robusta_cli/mason_bricks/robusta_new_project_bundle.dart';
import 'package:interact/interact.dart';
import 'package:mason/mason.dart' as mason;
import 'package:pubspec_parse/pubspec_parse.dart';

/// Make completes spinner
Spinner makeSpinner({
  required String onLoadMessage,
  required String completedMessage,
}) {
  return Spinner(
    /// Completes icon
    icon: '\u{2714}',
    rightPrompt: (done) => done ? onLoadMessage : completedMessage,
  );
}

/// Generate new project brick
Future<void> generateBrickNewProject({
  required String packageName,
  required Directory workingDirectory,
  bool runHook = true,
  mason.FileConflictResolution fileConflictResolution =
      mason.FileConflictResolution.overwrite,
}) async {
  return _generateBrick(
    generator: await mason.MasonGenerator.fromBundle(robustaNewProjectBundle),
    workingDirectory: workingDirectory,
    runHook: runHook,
    fileConflictResolution: fileConflictResolution,
  );
}

Future<void> _generateBrick({
  required mason.MasonGenerator generator,
  required Directory workingDirectory,
  Map<String, dynamic> vars = const {},
  bool runHook = true,
  mason.FileConflictResolution fileConflictResolution =
      mason.FileConflictResolution.overwrite,
}) async {
  final loading = makeSpinner(
    onLoadMessage: 'Generating Mason brick...',
    completedMessage: 'Generating Mason brick...',
  ).interact();

  if (runHook) {
    await generator.hooks.preGen(workingDirectory: workingDirectory.path);
  }

  await generator.generate(
    mason.DirectoryGeneratorTarget(workingDirectory),
    vars: vars,
    fileConflictResolution: fileConflictResolution,
  );

  if (runHook) {
    await generator.hooks.postGen(workingDirectory: workingDirectory.path);
  }

  loading.done();
}

/// Describing pubspec
Pubspec describePubspec(String pubspecPath) {
  final yaml = File(pubspecPath).readAsStringSync();

  return Pubspec.parse(yaml);
}
