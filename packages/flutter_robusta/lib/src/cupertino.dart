import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_robusta/src/app_extension.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:meta/meta.dart';

part 'cupertino.g.dart';

/// {@template cupertino.settings}
/// Instances of this class will support to settings [CupertinoApp] properties.
/// {@endtemplate cupertino.settings}
@CopyWith(skipFields: true)
class CupertinoAppSettings {
  /// {macro cupertino.settings}
  CupertinoAppSettings({
    this.key,
    this.backButtonDispatcher,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.useInheritedMediaQuery = false,
  });

  /// Alias of [CupertinoApp.key]
  final Key? key;

  /// Alias of [CupertinoApp.backButtonDispatcher]
  final BackButtonDispatcher? backButtonDispatcher;

  /// Alias of [CupertinoApp.title]
  final String title;

  /// Alias of [CupertinoApp.onGenerateTitle]
  final GenerateAppTitle? onGenerateTitle;

  /// Alias of [CupertinoApp.color]
  final Color? color;

  /// Alias of [CupertinoApp.theme]
  final CupertinoThemeData? theme;

  /// Alias of [CupertinoApp.locale]
  final Locale? locale;

  /// Alias of [CupertinoApp.localizationsDelegates]
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Alias of [CupertinoApp.localeListResolutionCallback]
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Alias of [CupertinoApp.localeResolutionCallback]
  final LocaleResolutionCallback? localeResolutionCallback;

  /// Alias of [CupertinoApp.supportedLocales]
  final Iterable<Locale> supportedLocales;

  /// Alias of [CupertinoApp.showPerformanceOverlay]
  final bool showPerformanceOverlay;

  /// Alias of [CupertinoApp.checkerboardRasterCacheImages]
  final bool checkerboardRasterCacheImages;

  /// Alias of [CupertinoApp.checkerboardOffscreenLayers]
  final bool checkerboardOffscreenLayers;

  /// Alias of [CupertinoApp.showSemanticsDebugger]
  final bool showSemanticsDebugger;

  /// Alias of [CupertinoApp.debugShowCheckedModeBanner]
  final bool debugShowCheckedModeBanner;

  /// Alias of [CupertinoApp.shortcuts]
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Alias of [CupertinoApp.actions]
  final Map<Type, Action<Intent>>? actions;

  /// Alias of [CupertinoApp.restorationScopeId]
  final String? restorationScopeId;

  /// Alias of [CupertinoApp.scrollBehavior]
  final ScrollBehavior? scrollBehavior;

  /// Alias of [CupertinoApp.useInheritedMediaQuery]
  final bool useInheritedMediaQuery;
}

/// {@template cupertino_extension}
/// An extension to settings, run [CupertinoApp] with [GoRouter], and open for
/// another extensions collaborating.
/// {@endtemplate}
@sealed
class CupertinoExtension extends AppExtension {
  /// {@macro cupertino_extension}
  CupertinoExtension({
    super.wrappers,
    super.routerSettings,
    CupertinoAppSettings? settings,
  }) : settings = settings ?? CupertinoAppSettings();

  /// Store settings of [CupertinoApp].
  CupertinoAppSettings settings;

  @override
  CupertinoApp appWidget(GoRouter router) {
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
}
