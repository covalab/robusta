import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final paths = [
    'lib/robusta/firebase_core.dart',
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
