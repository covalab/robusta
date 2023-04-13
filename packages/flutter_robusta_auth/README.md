Flutter Robusta Auth
====================

Providing security features to manage authentication and authorization for current identity using apps.

Installing
----------

Install this package via pub command:

```
flutter pub add flutter_robusta_auth
```

Usages
------

```dart
final runner = Runner(
  extensions: [
    FlutterAppExtension(routerSettings: RouterSettings()),
    FlutterAuthExtension(
      defineAccess: (definition) {
        definition
          ..define('guest', (identity, [arg]) => null == identity)
          ..define('user', (identity, [arg]) => null != identity);
      },
      defineScreenAccess: (definition) {
        definition.simpleDefine(
          pattern: '/user',
          abilities: ['user'],
          fallbackLocation: '/guest',
        );
      },
      identityProvider: (credentials, container) => Identity(
        id: '1',
        data: {},
      ),
    ),
  ],
);

Future<void> main() => runner.run();
```
