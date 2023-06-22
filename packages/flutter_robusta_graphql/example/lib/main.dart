import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';

FlutterAppExtension flutterAppExtension() {
  return FlutterAppExtension(routerSettings: RouterSettings());
}

FlutterGraphQLExtension flutterGraphQLExtension() {
  return FlutterGraphQLExtension(
    settings: GraphQLClientSettings(
      linkFactory: (c) => Link.from([
        HttpLink('https://your.upstream'),
      ]),
      cacheFactory: (c) => GraphQLCache(),
    ),
  );
}

final runner = Runner(
  extensions: [
    flutterAppExtension,
    flutterGraphQLExtension,
  ],
);

Future<void> main() => runner.run();
