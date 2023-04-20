import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final screenName = context.vars['name'] as String;
  final paths = [
    'lib/presentation/screens/${screenName.snakeCase}/screen.dart',
  ];

  for (final path in paths) {
    final file = File(path);

    if (file.existsSync()) {
      backupFile(file, '${file.path}.bak');
    }
  }
}

void backupFile(File file, String copyTo) {
  if (false == File(copyTo).existsSync()) {
    file.copySync(copyTo);
  } else {
    backupFile(file, '$copyTo.bak');
  }
}
