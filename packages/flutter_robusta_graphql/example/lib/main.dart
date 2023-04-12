import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';

final runner = Runner(
  extensions: [
    FlutterAppExtension(routerSettings: RouterSettings()),
    FlutterGraphQLExtension(
      settings: GraphQLClientSettings(
        linkFactory: (c) => Link.from([
          HttpLink('https://your.upstream'),
        ]),
        cacheFactory: (c) => GraphQLCache(),
      ),
    ),
  ],
);

Future<void> main() => runner.run();
