Flutter Robusta GraphQL
-----------------------

Integrate useful features of [GraphQL Flutter](https://pub.dev/packages/graphql_flutter) for Robusta apps.

Installation
============

Install this package via pub command:

```
flutter pub add flutter_robusta_graphql
```

Usages
======

```dart
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
```