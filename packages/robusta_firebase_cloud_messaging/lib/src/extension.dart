import 'dart:async';

import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// {@template robusta_firebase_cloud_messaging}
/// A Helper class for Firebase Cloud Messaiging
/// {@endtemplate}
class RobustaFirebaseCloudMessaging implements DependenceExtension {
  /// {@macro robusta_firebase_cloud_messaging}
  const RobustaFirebaseCloudMessaging();

  @override
  FutureOr<void> load(Configurator configurator) {
    _permissionRequest();
  }

  @override
  List<Type> dependsOn() => [RobustaFirebaseCoreExtension];

  void _permissionRequest() {}
}
