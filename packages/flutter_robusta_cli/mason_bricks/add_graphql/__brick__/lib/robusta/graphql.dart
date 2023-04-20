// import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';

FlutterGraphQLExtension graphQLExtension() {
  return FlutterGraphQLExtension(
    settings: GraphQLClientSettings(
      linkFactory: (container) {
        final links = <Link>[];

        // /// Integrate with Robusta auth to add authorization header
        // final authManager = container.read(authManagerProvider);
        //
        // links.add(
        //   AuthLink(
        //     getToken: () async {
        //       final credentials = await authManager.currentCredentials;
        //
        //       return credentials?['access_token'];
        //     },
        //   ),
        // );

        links.add(
          HttpLink(
            const String.fromEnvironment(
              'APP_UPSTREAM_URI',
              defaultValue: 'https://your.upstream',
            ),
          ),
        );

        return Link.from(links);
      },
      cacheFactory: (container) => GraphQLCache(
        store: HiveStore(),
      ),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
        ),
      ),
    ),
  );
}
