import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';

part 'material.g.dart';

/// {@template material.settings}
/// Instances of this class will support settings [MaterialApp]'s properties.
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
