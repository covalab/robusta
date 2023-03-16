import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_robusta/src/app_extension.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:meta/meta.dart';

part 'material.g.dart';

/// {@template material.settings}
/// Instances of this class will support to settings [MaterialApp] properties.
/// {@endtemplate material.settings}
@CopyWith(skipFields: true)
class MaterialAppSettings {
  /// {@macro material.settings}
  MaterialAppSettings({
    this.key,
    this.scaffoldMessengerKey,
    this.backButtonDispatcher,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
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

  /// Alias of [MaterialApp.key]
  final Key? key;

  /// Alias of [MaterialApp.scaffoldMessengerKey]
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// Alias of [MaterialApp.backButtonDispatcher]
  final BackButtonDispatcher? backButtonDispatcher;

  /// Alias of [MaterialApp.title]
  final String title;

  /// Alias of [MaterialApp.onGenerateTitle]
  final GenerateAppTitle? onGenerateTitle;

  /// Alias of [MaterialApp.color]
  final Color? color;

  /// Alias of [MaterialApp.theme]
  final ThemeData? theme;

  /// Alias of [MaterialApp.darkTheme]
  final ThemeData? darkTheme;

  /// Alias of [MaterialApp.highContrastTheme]
  final ThemeData? highContrastTheme;

  /// Alias of [MaterialApp.highContrastDarkTheme]
  final ThemeData? highContrastDarkTheme;

  /// Alias of [MaterialApp.themeMode]
  final ThemeMode? themeMode;

  /// Alias of [MaterialApp.themeAnimationDuration]
  final Duration themeAnimationDuration;

  /// Alias of [MaterialApp.themeAnimationCurve]
  final Curve themeAnimationCurve;

  /// Alias of [MaterialApp.locale]
  final Locale? locale;

  /// Alias of [MaterialApp.localizationsDelegates]
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Alias of [MaterialApp.localeListResolutionCallback]
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Alias of [MaterialApp.localeResolutionCallback]
  final LocaleResolutionCallback? localeResolutionCallback;

  /// Alias of [MaterialApp.supportedLocales]
  final Iterable<Locale> supportedLocales;

  /// Alias of [MaterialApp.showPerformanceOverlay]
  final bool showPerformanceOverlay;

  /// Alias of [MaterialApp.checkerboardRasterCacheImages]
  final bool checkerboardRasterCacheImages;

  /// Alias of [MaterialApp.checkerboardOffscreenLayers]
  final bool checkerboardOffscreenLayers;

  /// Alias of [MaterialApp.showSemanticsDebugger]
  final bool showSemanticsDebugger;

  /// Alias of [MaterialApp.debugShowCheckedModeBanner]
  final bool debugShowCheckedModeBanner;

  /// Alias of [MaterialApp.shortcuts]
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Alias of [MaterialApp.actions]
  final Map<Type, Action<Intent>>? actions;

  /// Alias of [MaterialApp.restorationScopeId]
  final String? restorationScopeId;

  /// Alias of [MaterialApp.scrollBehavior]
  final ScrollBehavior? scrollBehavior;

  /// Alias of [MaterialApp.debugShowMaterialGrid]
  final bool debugShowMaterialGrid;

  /// Alias of [MaterialApp.useInheritedMediaQuery]
  final bool useInheritedMediaQuery;
}

/// {@template material_extension}
/// An extension to settings, run [MaterialApp] with [GoRouter], and open for
/// another extensions collaborating.
/// {@endtemplate}
@sealed
class MaterialExtension extends AppExtension {
  /// {@macro material_extension}
  MaterialExtension({
    super.wrappers,
    super.routerSettings,
    MaterialAppSettings? settings,
  }) : settings = settings ?? MaterialAppSettings();

  /// Store settings of [MaterialApp].
  MaterialAppSettings settings;

  @override
  MaterialApp appWidget(GoRouter router) {
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
}
