import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:meta/meta.dart';

part 'router.g.dart';

typedef _Factory<T> = FutureOr<T> Function(ProviderContainer);

/// Creating screen with provider container as an arg for solving dependencies.
typedef ScreenFactory = _Factory<ScreenBase>;

/// Creating refresh notifier with provider container as an arg for
/// solving dependencies.
typedef RefreshNotifierFactory = _Factory<Listenable>;

/// Creating redirector with provider container as an arg for
/// solving dependencies.
typedef RedirectorFactory = _Factory<Redirector>;

/// Creating navigator observer with provider container as an arg for
/// solving dependencies.
typedef NavigatorObserverFactory = _Factory<NavigatorObserver>;

/// {@template router.settings}
/// Instances of this class supports router settings.
/// {@endtemplate}
@CopyWith(skipFields: true)
@sealed
class RouterSettings {
  /// {@macro router.settings}
  RouterSettings({
    List<ScreenFactory> screenFactories = const [],
    List<RefreshNotifierFactory> refreshNotifierFactories = const [],
    List<RedirectorFactory> redirectorFactories = const [],
    List<NavigatorObserverFactory> navigatorObserversFactories = const [],
    this.routerNeglect = false,
    this.redirectLimit = 8,
    this.debugLogDiagnostics = false,
    this.restorationScopeId,
    this.navigatorKey,
    this.initialExtra,
  })  : screenFactories = [...screenFactories],
        refreshNotifierFactories = [...refreshNotifierFactories],
        redirectorFactories = [...redirectorFactories],
        navigatorObserversFactories = [...navigatorObserversFactories];

  /// Screen factories.
  final List<ScreenFactory> screenFactories;

  /// Refresh notifiers factories.
  final List<RefreshNotifierFactory> refreshNotifierFactories;

  /// Redirector factories.
  final List<RedirectorFactory> redirectorFactories;

  /// Navigator observer factories.
  final List<NavigatorObserverFactory> navigatorObserversFactories;

  /// Set to true to disable creating history entries on the web.
  final bool routerNeglect;

  /// The limit for the number of consecutive redirects.
  final int redirectLimit;

  /// Whether to forwards diagnostic messages to the dart:developer log() API.
  final bool debugLogDiagnostics;

  /// Restoration ID to save and restore the state of the navigator, including
  /// its history.
  final String? restorationScopeId;

  /// The key to use when building the root [Navigator].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Initial extra data pass to initial screen.
  final Object? initialExtra;

  /// Returns list of screens factored with container given.
  Future<List<ScreenBase>> getScreens(ProviderContainer container) {
    return Future.wait(
      screenFactories.map(
        (factory) async => factory(container),
      ),
    );
  }

  /// Returns list of refresh notifiers factored with container given.
  Future<List<Listenable>> getRefreshNotifiers(ProviderContainer container) {
    return Future.wait(
      refreshNotifierFactories.map(
        (factory) async => factory(container),
      ),
    );
  }

  /// Returns list of redirectors factored with container given.
  Future<List<Redirector>> getRedirectors(
    ProviderContainer container,
  ) {
    return Future.wait(
      redirectorFactories.map(
        (factory) async => factory(container),
      ),
    );
  }

  /// Returns list of navigator observers factored with container given.
  Future<List<NavigatorObserver>> getNavigatorObservers(
    ProviderContainer container,
  ) {
    return Future.wait(
      navigatorObserversFactories.map(
        (factory) async => factory(container),
      ),
    );
  }
}
