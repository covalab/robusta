import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

/// Callback to create [Link] with [ProviderContainer] given
/// to solve dependencies.
typedef LinkFactory = Link Function(ProviderContainer);

/// Callback to create [GraphQLCache] with [ProviderContainer] given
/// to solve dependencies.
typedef CacheFactory = GraphQLCache Function(ProviderContainer);

/// {@template graphql_client.settings}
/// Store settings of [GraphQLClient].
/// {@endtemplate}
@sealed
class GraphQLClientSettings {
  /// {@macro graphql_client.settings}
  GraphQLClientSettings({
    required this.linkFactory,
    required this.cacheFactory,
    this.alwaysRebroadcast = false,
    this.defaultPolicies,
  });

  /// An alias of [QueryManager.alwaysRebroadcast].
  final bool alwaysRebroadcast;

  /// Factory to create [GraphQLClient.link].
  final LinkFactory linkFactory;

  /// Factory to create [GraphQLClient.cache].
  final CacheFactory cacheFactory;

  /// An alias of [GraphQLClient.defaultPolicies].
  final DefaultPolicies? defaultPolicies;
}

/// An interface to mark classes aware [GraphQLClient] and should be set
/// after instance of it created.
// ignore: one_member_abstracts
abstract class GraphQLClientAware {
  /// Set graphql client, method should be invoke after instance created.
  void setGraphQLClient(GraphQLClient client);
}

/// Support to quick implement [GraphQLClientAware].
mixin GraphQLClientSettable implements GraphQLClientAware {
  late final GraphQLClient _graphQLClient;

  /// GraphQL client had set via [setGraphQLClient].
  GraphQLClient get graphQLClient => _graphQLClient;

  @override
  void setGraphQLClient(GraphQLClient client) => _graphQLClient = client;
}
