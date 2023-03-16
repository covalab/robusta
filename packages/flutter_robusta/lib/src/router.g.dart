// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RouterSettingsCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// RouterSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  RouterSettings call({
    List<FutureOr<ScreenBase> Function(ProviderContainer)>? screenFactories,
    List<FutureOr<Listenable> Function(ProviderContainer)>?
        refreshNotifierFactories,
    List<FutureOr<Redirector> Function(ProviderContainer)>? redirectorFactories,
    List<FutureOr<NavigatorObserver> Function(ProviderContainer)>?
        navigatorObserversFactories,
    bool? routerNeglect,
    int? redirectLimit,
    bool? debugLogDiagnostics,
    String? restorationScopeId,
    GlobalKey<NavigatorState>? navigatorKey,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRouterSettings.copyWith(...)`.
class _$RouterSettingsCWProxyImpl implements _$RouterSettingsCWProxy {
  const _$RouterSettingsCWProxyImpl(this._value);

  final RouterSettings _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// RouterSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  RouterSettings call({
    Object? screenFactories = const $CopyWithPlaceholder(),
    Object? refreshNotifierFactories = const $CopyWithPlaceholder(),
    Object? redirectorFactories = const $CopyWithPlaceholder(),
    Object? navigatorObserversFactories = const $CopyWithPlaceholder(),
    Object? routerNeglect = const $CopyWithPlaceholder(),
    Object? redirectLimit = const $CopyWithPlaceholder(),
    Object? debugLogDiagnostics = const $CopyWithPlaceholder(),
    Object? restorationScopeId = const $CopyWithPlaceholder(),
    Object? navigatorKey = const $CopyWithPlaceholder(),
  }) {
    return RouterSettings(
      screenFactories: screenFactories == const $CopyWithPlaceholder() ||
              screenFactories == null
          ? _value.screenFactories
          // ignore: cast_nullable_to_non_nullable
          : screenFactories
              as List<FutureOr<ScreenBase> Function(ProviderContainer)>,
      refreshNotifierFactories:
          refreshNotifierFactories == const $CopyWithPlaceholder() ||
                  refreshNotifierFactories == null
              ? _value.refreshNotifierFactories
              // ignore: cast_nullable_to_non_nullable
              : refreshNotifierFactories
                  as List<FutureOr<Listenable> Function(ProviderContainer)>,
      redirectorFactories:
          redirectorFactories == const $CopyWithPlaceholder() ||
                  redirectorFactories == null
              ? _value.redirectorFactories
              // ignore: cast_nullable_to_non_nullable
              : redirectorFactories
                  as List<FutureOr<Redirector> Function(ProviderContainer)>,
      navigatorObserversFactories: navigatorObserversFactories ==
                  const $CopyWithPlaceholder() ||
              navigatorObserversFactories == null
          ? _value.navigatorObserversFactories
          // ignore: cast_nullable_to_non_nullable
          : navigatorObserversFactories
              as List<FutureOr<NavigatorObserver> Function(ProviderContainer)>,
      routerNeglect:
          routerNeglect == const $CopyWithPlaceholder() || routerNeglect == null
              ? _value.routerNeglect
              // ignore: cast_nullable_to_non_nullable
              : routerNeglect as bool,
      redirectLimit:
          redirectLimit == const $CopyWithPlaceholder() || redirectLimit == null
              ? _value.redirectLimit
              // ignore: cast_nullable_to_non_nullable
              : redirectLimit as int,
      debugLogDiagnostics:
          debugLogDiagnostics == const $CopyWithPlaceholder() ||
                  debugLogDiagnostics == null
              ? _value.debugLogDiagnostics
              // ignore: cast_nullable_to_non_nullable
              : debugLogDiagnostics as bool,
      restorationScopeId: restorationScopeId == const $CopyWithPlaceholder()
          ? _value.restorationScopeId
          // ignore: cast_nullable_to_non_nullable
          : restorationScopeId as String?,
      navigatorKey: navigatorKey == const $CopyWithPlaceholder()
          ? _value.navigatorKey
          // ignore: cast_nullable_to_non_nullable
          : navigatorKey as GlobalKey<NavigatorState>?,
    );
  }
}

extension $RouterSettingsCopyWith on RouterSettings {
  /// Returns a callable class that can be used as follows: `instanceOfRouterSettings.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$RouterSettingsCWProxy get copyWith => _$RouterSettingsCWProxyImpl(this);
}
