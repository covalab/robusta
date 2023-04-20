import 'dart:io';

Future<void> main() async {
  final stack = {
    'flutter_robusta_cli': [
      'new_project',
      'add_auth',
      'add_dio',
      'add_graphql',
      'add_hive',
      'add_firebase_core',
      'gen_repo',
      'gen_screen',
    ],
  };

  for (final entry in stack.entries) {
    final package = entry.key;

    for (final brick in entry.value) {
      await Process.run(
        'mason',
        [
          'bundle',
          './packages/$package/mason_bricks/$brick',
          '-t',
          'dart',
          '-o',
          './packages/$package/lib/mason_bricks',
        ],
        runInShell: true,
      );
    }
  }

  await Future.wait([stderr.close(), stdout.close()]);

  exit(0);
}
