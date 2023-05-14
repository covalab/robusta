import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

/// Uses to run process
typedef ProcessRunnable = FutureOr<int> Function(
  String, {
  required List<String> args,
  Logger? logger,
  Directory? workingDirectory,
});

/// Default process runner
Future<int> nativeRunCommand(
  String cmd, {
  required List<String> args,
  Logger? logger,
  Directory? workingDirectory,
}) async {
  workingDirectory ??= Directory.current;

  final result = await Process.run(
    cmd,
    args,
    workingDirectory: workingDirectory.absolute.path,
  );

  if (null != result.stdout && result.exitCode != 0) {
    logger?.e('Error when run command $cmd: ${result.stdout}');
  }

  if (null != result.stderr && result.exitCode != 0) {
    logger?.e('Error when run command $cmd: ${result.stderr}');
  }

  return result.exitCode;
}
