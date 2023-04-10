import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';
import 'package:graphql/src/graphql_client.dart';

class Test implements GraphQLClientAware {
  GraphQLClient? client;

  @override
  void setGraphQLClient(GraphQLClient client) => this.client = client;
}

final testProvider = Provider<Test>((_) => Test());
