import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const _unimplementedErrorMsg =
    'Outside of FlutterGraphQLExtension, this provider not implemented.';

/// Providing [GraphQLClient] to interact with your upstream API.
final graphQLClientProvider = Provider<GraphQLClient>(
  (_) => throw UnimplementedError(_unimplementedErrorMsg),
);
