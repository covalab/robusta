import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// {@template robusta_firebase_core}
/// A Helper class for Firebase core initialization.
/// {@endtemplate}
class FirebaseCoreExtension implements Extension {
  /// {@macro flutter_robusta_firebase_core}
  const FirebaseCoreExtension({String? name, FirebaseOptions? options})
      : _name = name,
        _firebaseOptions = options;

  final String? _name;
  final FirebaseOptions? _firebaseOptions;

  @override
  void load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 4096);
  }

  Future<void> _boot(ProviderContainer providerContainer) async {
    await Firebase.initializeApp(name: _name, options: _firebaseOptions);
  }
}
