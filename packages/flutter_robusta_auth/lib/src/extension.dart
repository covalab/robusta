import 'dart:async';

import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:flutter_robusta_hive/flutter_robusta_hive.dart';
import 'package:go_router_plus/go_router_plus.dart';

/// {@template flutter_robusta_auth}
/// An extension providing authn/authz features.
/// {@endtemplate}
class FlutterAuthExtension implements DependenceExtension {
  /// {@macro flutter_robusta_auth}
  FlutterAuthExtension({bool persistToken = true})
      : _persistToken = persistToken;

  final bool _persistToken;

  @override
  List<Type> dependsOn() {
    return [
      if (_persistToken) FlutterHiveExtension,
    ];
  }

  @override
  FutureOr<void> load(Configurator configurator) {
    RouterSettings? routerSettings;

    if (configurator.hasExtension<MaterialExtension>()) {
      routerSettings =
          configurator.getExtension<MaterialExtension>().routerSettings;
    } else if (configurator.hasExtension<CupertinoExtension>()) {
      routerSettings =
          configurator.getExtension<CupertinoExtension>().routerSettings;
    }

    if (null == routerSettings) {
      throw FlutterAuthException.appExtensionNotFound();
    }

    routerSettings.redirectorFactories.add((_) => ScreenRedirector());
  }
}
