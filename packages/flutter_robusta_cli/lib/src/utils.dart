import 'dart:async';
import 'dart:io';

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

/// Generate brick
Future<void> generateBricks({
  required List<mason.MasonBundle> bundles,
  required Directory workingDirectory,
  Map<String, dynamic> vars = const {},
  bool runHook = true,
  mason.FileConflictResolution fileConflictResolution =
      mason.FileConflictResolution.overwrite,
}) async {
  final loading = makeSpinner(
    onLoadMessage: 'Generating Mason bricks...',
    completedMessage: 'Generating Mason bricks...',
  ).interact();

  for (final bundle in bundles) {
    final generator = await mason.MasonGenerator.fromBundle(bundle);

    if (runHook) {
      await generator.hooks.preGen(
        workingDirectory: workingDirectory.path,
        vars: vars,
      );
    }

    await generator.generate(
      mason.DirectoryGeneratorTarget(workingDirectory),
      vars: vars,
      fileConflictResolution: fileConflictResolution,
    );

    if (runHook) {
      await generator.hooks.postGen(
        workingDirectory: workingDirectory.path,
        vars: vars,
      );
    }
  }

  loading.done();
}

/// Describing pubspec
Pubspec describePubspec(String pubspecPath) {
  final yaml = File(pubspecPath).readAsStringSync();

  return Pubspec.parse(yaml);
}
