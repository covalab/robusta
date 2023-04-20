import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_add_auth_bundle.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_add_dio_bundle.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_add_firebase_core_bundle.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_add_graphql_bundle.dart';
import 'package:flutter_robusta_cli/mason_bricks/robusta_add_hive_bundle.dart';
import 'package:flutter_robusta_cli/src/flutter.dart';
import 'package:flutter_robusta_cli/src/utils.dart';
import 'package:logger/logger.dart';
import 'package:mason/mason.dart' as mason;

/// {@template add_command}
/// Help to add quick add extensions.
/// {@endtemplate}
class AddCommand extends Command<int> {
  /// {@macro add_command}
  AddCommand({
    required FlutterBin flutterBin,
    required Logger logger,
  })  : _flutterBin = flutterBin,
        _logger = logger;

  final FlutterBin _flutterBin;

  final Logger _logger;

  @override
  String get description => 'Help to quick add extensions';

  @override
  String get name => 'add';

  @override
  String get invocation => 'robsuta add [extension_name]';

  /// Mapping aliases with bundles requires
  // TODO(Minh): fetches from remote upstream instead hardcode.
  static final Map<List<String>, List<mason.MasonBundle>> _bundles = {
    ['auth']: [robustaAddAuthBundle, robustaAddHiveBundle],
    ['dio']: [robustaAddDioBundle],
    ['graphql']: [robustaAddGraphqlBundle],
    ['hive']: [robustaAddHiveBundle],
    ['firebase_core', 'firebase']: [robustaAddFirebaseCoreBundle],
  };

  /// Mapping aliases with pub dependencies
  // TODO(Minh): fetches from remote upstream instead hardcode.
  static final Map<List<String>, List<String>> _dependencies = {
    ['auth']: [
      'flutter_robusta_auth',
      'flutter_robusta_hive',
      'flutter_robusta_hive_auth',
    ],
    ['dio']: [
      'robusta_dio',
    ],
    ['graphql']: [
      'flutter_robusta_graphql',
    ],
    ['hive']: [
      'flutter_robusta_hive',
    ],
    ['firebase_core', 'firebase']: [
      'robusta_firebase_core',
    ],
  };

  @override
  Future<int>? run() async {
    try {
      describePubspec('${Directory.current.path}/pubspec.yaml');
    } on Exception {
      usageException('Pubspec not found or invalid');
    }

    if (_pubDependencies.isEmpty && _masonBundles.isEmpty) {
      usageException('Not support to add extension: $_extensionName');
    }

    await _flutterBin.ensureFlutterInstalled();

    if (_pubDependencies.isNotEmpty) {
      await _flutterBin.addPubDependencies(
        dependencies: _pubDependencies,
        workingDirectory: Directory.current,
      );
    }

    if (_masonBundles.isNotEmpty) {
      await generateBricks(
        bundles: _masonBundles,
        workingDirectory: Directory.current,
      );

      _logger.i('Tip: add generated extension to Runner `extensions`');
    }

    _logger.i('Add $_extensionName extension successful!');

    return 0;
  }

  String get _extensionName {
    final args = argResults!.rest;

    if (args.isEmpty) {
      usageException('No option specified for the extension name.');
    }

    return args.first;
  }

  List<mason.MasonBundle> get _masonBundles {
    final ext = _extensionName;

    for (final entry in _bundles.entries) {
      if (entry.key.contains(ext)) {
        return entry.value;
      }
    }

    return [];
  }

  List<String> get _pubDependencies {
    final ext = _extensionName;

    for (final entry in _dependencies.entries) {
      if (entry.key.contains(ext)) {
        return entry.value;
      }
    }

    return [];
  }
}
