import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/src/router.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:meta/meta.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// Use to wrap app widget with another widget for providing
/// features like inherited widget.
typedef AppWidgetWrapper = Widget Function(Widget appWidget);

/// {@template app_extension}
/// App extension base of Material and Cupertino
/// {@endtemplate}
@internal
abstract class AppExtension implements Extension {
  /// {@macro app_extension}
  AppExtension({
    Map<AppWidgetWrapper, int>? wrappers,
    RouterSettings? routerSettings,
  })  : _wrappers = {...wrappers ?? {}},
        routerSettings = routerSettings ?? RouterSettings();

  final Map<AppWidgetWrapper, int> _wrappers;

  /// Settings of [GoRouter].
  RouterSettings routerSettings;

  @override
  void load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 8192);
  }

  void _boot(ProviderContainer container) {
    FlutterError.onError = (details) {
      Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.empty,
      );
    };

    container
        .read(eventManagerProvider)
        .addEventListener<RunEvent>(_onRun, priority: 8192);
  }

  Future<void> _onRun(RunEvent event) async {
    final router = await _getRouter(event.container);
    var app = appWidget(router);

    for (final wrapper in _sortedWrappers) {
      app = wrapper(app);
    }

    if (app is! ProviderScope || app.parent != event.container) {
      app = ProviderScope(
        parent: event.container,
        child: app,
      );
    }

    runApp(app);
  }

  /// App widget using to run.
  @protected
  Widget appWidget(GoRouter router);

  /// Methods support nother extensions can collaborate.
  void addAppWidgetWrapper(AppWidgetWrapper wrapper, {int priority = 0}) {
    _wrappers[wrapper] = priority;
  }

  Iterable<AppWidgetWrapper> get _sortedWrappers {
    final entries = _wrappers.entries.toList()
      ..sort(
        (e1, e2) => e2.value.compareTo(e1.value),
      );

    return entries.map((e) => e.key);
  }

  /// Get router based on current [routerSettings] values.
  Future<GoRouter> _getRouter(ProviderContainer container) async {
    return createGoRouter(
      screens: await routerSettings.getScreens(container),
      observers: await routerSettings.getNavigatorObservers(container),
      redirectors: await routerSettings.getRedirectors(container),
      refreshNotifiers: await routerSettings.getRefreshNotifiers(container),
      navigatorKey: routerSettings.navigatorKey,
      debugLogDiagnostics: routerSettings.debugLogDiagnostics,
      redirectLimit: routerSettings.redirectLimit,
      restorationScopeId: routerSettings.restorationScopeId,
      routerNeglect: routerSettings.routerNeglect,
    );
  }
}
