import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'cupertino.g.dart';

/// {@template cupertino.settings}
/// Instances of this class will support setting [CupertinoApp]'s properties.
/// {@endtemplate cupertino.settings}
@CopyWith(skipFields: true)
@sealed
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
