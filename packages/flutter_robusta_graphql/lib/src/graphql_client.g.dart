// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_client.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GraphQLClientSettingsCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GraphQLClientSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  GraphQLClientSettings call({
    Link Function(ProviderContainer)? linkFactory,
    GraphQLCache Function(ProviderContainer)? cacheFactory,
    bool? alwaysRebroadcast,
    DefaultPolicies? defaultPolicies,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGraphQLClientSettings.copyWith(...)`.
class _$GraphQLClientSettingsCWProxyImpl
    implements _$GraphQLClientSettingsCWProxy {
  const _$GraphQLClientSettingsCWProxyImpl(this._value);

  final GraphQLClientSettings _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GraphQLClientSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  GraphQLClientSettings call({
    Object? linkFactory = const $CopyWithPlaceholder(),
    Object? cacheFactory = const $CopyWithPlaceholder(),
    Object? alwaysRebroadcast = const $CopyWithPlaceholder(),
    Object? defaultPolicies = const $CopyWithPlaceholder(),
  }) {
    return GraphQLClientSettings(
      linkFactory:
          linkFactory == const $CopyWithPlaceholder() || linkFactory == null
              ? _value.linkFactory
              // ignore: cast_nullable_to_non_nullable
              : linkFactory as Link Function(ProviderContainer),
      cacheFactory:
          cacheFactory == const $CopyWithPlaceholder() || cacheFactory == null
              ? _value.cacheFactory
              // ignore: cast_nullable_to_non_nullable
              : cacheFactory as GraphQLCache Function(ProviderContainer),
      alwaysRebroadcast: alwaysRebroadcast == const $CopyWithPlaceholder() ||
              alwaysRebroadcast == null
          ? _value.alwaysRebroadcast
          // ignore: cast_nullable_to_non_nullable
          : alwaysRebroadcast as bool,
      defaultPolicies: defaultPolicies == const $CopyWithPlaceholder()
          ? _value.defaultPolicies
          // ignore: cast_nullable_to_non_nullable
          : defaultPolicies as DefaultPolicies?,
    );
  }
}

extension $GraphQLClientSettingsCopyWith on GraphQLClientSettings {
  /// Returns a callable class that can be used as follows: `instanceOfGraphQLClientSettings.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GraphQLClientSettingsCWProxy get copyWith =>
      _$GraphQLClientSettingsCWProxyImpl(this);
}
