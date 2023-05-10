---
id: flutter-robusta-auth
title: Flutter Robusta Auth
sidebar_position: 6
---

### Prerequites 📝

### Installing ⚙️

### Usage

Create the runner and use Material/Cupertino to run your app

```js
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

### API
