import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/src/cupertino.dart';
import 'package:flutter_robusta/src/material.dart';
import 'package:flutter_robusta/src/router.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:meta/meta.dart';
import 'package:robusta_runner/robusta_runner.dart';

/// Use to wrap app widget with another widget for providing
/// features like inherited widget.
typedef AppWidgetWrapper = Widget Function(Widget appWidget);

/// {@template app_extension}
/// Robusta extension for running Flutter apps.
/// {@endtemplate}
@sealed
class FlutterAppExtension implements Extension {
  /// {@macro app_extension}
  FlutterAppExtension({
    required RouterSettings routerSettings,
    Map<AppWidgetWrapper, int>? wrappers,
    CupertinoAppSettings? cupertinoAppSettings,
    MaterialAppSettings? materialAppSettings,
  })  : _routerSettings = routerSettings,
        _wrappers = {...wrappers ?? {}},
        _cupertinoAppSettings = cupertinoAppSettings,
        _materialAppSettings = materialAppSettings {
    /// Use Material as default app for running.
    if (null == _materialAppSettings && null == _cupertinoAppSettings) {
      _materialAppSettings = MaterialAppSettings();
    }
  }

  final Map<AppWidgetWrapper, int> _wrappers;

  RouterSettings _routerSettings;

  MaterialAppSettings? _materialAppSettings;

  CupertinoAppSettings? _cupertinoAppSettings;

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
    var app = _appWidget(router);

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

  Widget _appWidget(GoRouter router) {
    if (null != _materialAppSettings) {
      final settings = _materialAppSettings!;

      return MaterialApp.router(
        routerConfig: router,
        key: settings.key,
        scaffoldMessengerKey: settings.scaffoldMessengerKey,
        backButtonDispatcher: settings.backButtonDispatcher,
        title: settings.title,
        onGenerateTitle: settings.onGenerateTitle,
        color: settings.color,
        theme: settings.theme,
        darkTheme: settings.darkTheme,
        highContrastTheme: settings.highContrastTheme,
        highContrastDarkTheme: settings.highContrastDarkTheme,
        themeMode: settings.themeMode,
        themeAnimationDuration: settings.themeAnimationDuration,
        themeAnimationCurve: settings.themeAnimationCurve,
        locale: settings.locale,
        localizationsDelegates: settings.localizationsDelegates,
        localeListResolutionCallback: settings.localeListResolutionCallback,
        localeResolutionCallback: settings.localeResolutionCallback,
        supportedLocales: settings.supportedLocales,
        debugShowMaterialGrid: settings.debugShowMaterialGrid,
        showPerformanceOverlay: settings.showPerformanceOverlay,
        checkerboardRasterCacheImages: settings.checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: settings.checkerboardOffscreenLayers,
        showSemanticsDebugger: settings.showSemanticsDebugger,
        debugShowCheckedModeBanner: settings.debugShowCheckedModeBanner,
        shortcuts: settings.shortcuts,
        actions: settings.actions,
        restorationScopeId: settings.restorationScopeId,
        scrollBehavior: settings.scrollBehavior,
        useInheritedMediaQuery: settings.useInheritedMediaQuery,
      );
    }

    final settings = _cupertinoAppSettings!;

    return CupertinoApp.router(
      routerConfig: router,
      key: settings.key,
      backButtonDispatcher: settings.backButtonDispatcher,
      title: settings.title,
      onGenerateTitle: settings.onGenerateTitle,
      color: settings.color,
      theme: settings.theme,
      locale: settings.locale,
      localizationsDelegates: settings.localizationsDelegates,
      localeListResolutionCallback: settings.localeListResolutionCallback,
      localeResolutionCallback: settings.localeResolutionCallback,
      supportedLocales: settings.supportedLocales,
      showPerformanceOverlay: settings.showPerformanceOverlay,
      checkerboardRasterCacheImages: settings.checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: settings.checkerboardOffscreenLayers,
      showSemanticsDebugger: settings.showSemanticsDebugger,
      debugShowCheckedModeBanner: settings.debugShowCheckedModeBanner,
      shortcuts: settings.shortcuts,
      actions: settings.actions,
      restorationScopeId: settings.restorationScopeId,
      scrollBehavior: settings.scrollBehavior,
      useInheritedMediaQuery: settings.useInheritedMediaQuery,
    );
  }

  Iterable<AppWidgetWrapper> get _sortedWrappers {
    final entries = _wrappers.entries.toList()
      ..sort(
        (e1, e2) => e2.value.compareTo(e1.value),
      );

    return entries.map((e) => e.key);
  }

  /// Get router based on current [_routerSettings] values.
  Future<GoRouter> _getRouter(ProviderContainer container) async {
    return createGoRouter(
      screens: await _routerSettings.getScreens(container),
      observers: await _routerSettings.getNavigatorObservers(container),
      redirectors: await _routerSettings.getRedirectors(container),
      refreshNotifiers: await _routerSettings.getRefreshNotifiers(container),
      navigatorKey: _routerSettings.navigatorKey,
      debugLogDiagnostics: _routerSettings.debugLogDiagnostics,
      redirectLimit: _routerSettings.redirectLimit,
      restorationScopeId: _routerSettings.restorationScopeId,
      routerNeglect: _routerSettings.routerNeglect,
    );
  }
}

/// Dart extension for adding utils to interact with [FlutterAppExtension].
extension FlutterAppExtensionConfigurator on Configurator {
  /// Get [GoRouter] settings.
  RouterSettings get routerSettings {
    return getExtension<FlutterAppExtension>()._routerSettings;
  }

  /// Set [GoRouter] settings.
  set routerSettings(RouterSettings settings) {
    getExtension<FlutterAppExtension>()._routerSettings = settings;
  }

  /// Get [MaterialApp] settings.
  MaterialAppSettings? get materialAppSettings {
    return getExtension<FlutterAppExtension>()._materialAppSettings;
  }

  /// Set [MaterialApp] settings.
  set materialAppSettings(MaterialAppSettings? settings) {
    getExtension<FlutterAppExtension>()._materialAppSettings = settings;
  }

  /// Get [CupertinoApp] settings.
  CupertinoAppSettings? get cupertinoAppSettings {
    return getExtension<FlutterAppExtension>()._cupertinoAppSettings;
  }

  /// Set [CupertinoApp] settings.
  set cupertinoAppSettings(CupertinoAppSettings? settings) {
    getExtension<FlutterAppExtension>()._cupertinoAppSettings = settings;
  }

  /// Add app wrapper for adding feature like inherited widget for your app.
  void addAppWidgetWrapper(AppWidgetWrapper wrapper, {int priority = 0}) {
    getExtension<FlutterAppExtension>()._wrappers[wrapper] = priority;
  }
}
