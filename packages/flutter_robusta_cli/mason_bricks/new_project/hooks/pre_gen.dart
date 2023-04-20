import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
    Directory('lib').deleteSync(recursive: true);
    Directory('test').deleteSync(recursive: true);
}
