import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_graphql/src/graphql.dart';
import 'package:flutter_robusta_graphql/src/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

/// {@template extension.flutter_graphql}
/// An extension to integrate GraphQL features for Robusta runner.
/// {@endtemplate}
@sealed
class FlutterGraphQLExtension implements DependenceExtension {
  /// {@macro extension.flutter_graphql}
  FlutterGraphQLExtension({
    required GraphQLClientSettings settings,
    bool enabledGraphQLProvider = true,
  })  : _settings = settings,
        _enabledGraphQLProvider = enabledGraphQLProvider;

  final bool _enabledGraphQLProvider;

  final GraphQLClientSettings _settings;

  @override
  List<Type> dependsOn() {
    return [
      if (_enabledGraphQLProvider) FlutterAppExtension,
    ];
  }

  @override
  FutureOr<void> load(Configurator configurator) {
    configurator.addContainerOverride(_graphQLClientOverride());

    if (_enabledGraphQLProvider) {
      configurator.addAppWidgetWrapper(_wrapper, priority: 32);
    }

    if (configurator.hasExtension<ImplementingCallbackExtension>()) {
      configurator.defineImplementingCallback<GraphQLClientAware>(
        (instance, container) => instance.setGraphQLClient(
          container.read(graphQLClientProvider),
        ),
      );
    }
  }

  Override _graphQLClientOverride() {
    return graphQLClientProvider.overrideWith(
      (ref) {
        return GraphQLClient(
          link: _settings.linkFactory(ref.container),
          cache: _settings.cacheFactory(ref.container),
          defaultPolicies: _settings.defaultPolicies,
          alwaysRebroadcast: _settings.alwaysRebroadcast,
        );
      },
    );
  }

  Widget _wrapper(Widget widget) {
    return Consumer(
      builder: (ctx, ref, child) => GraphQLProvider(
        client: ValueNotifier<GraphQLClient>(
          ref.watch(graphQLClientProvider),
        ),
        child: child,
      ),
      child: widget,
    );
  }
}
