---
id: customize-extension
title: Customize Extension
sidebar_position: 3
---

If you can't find any built-in extensions that serve your needs. Don't worry, **Robusta** have you cover.

You can implement class `Extension` and write your own logics inside and plug your own `Extension` inside the **Runner**

```js title="Firebase Core Extension"
/// {@template robusta_firebase_core}
/// A Helper class for Firebase core initialization.
/// {@endtemplate}
class FirebaseCoreExtension implements Extension {
  /// {@macro flutter_robusta_firebase_core}
  const FirebaseCoreExtension({String? name, FirebaseOptions? options})
      : _name = name,
        _firebaseOptions = options;

  final String? _name;
  final FirebaseOptions? _firebaseOptions;

  @override
  void load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 4096);
  }

  Future<void> _boot(ProviderContainer providerContainer) async {
    await Firebase.initializeApp(name: _name, options: _firebaseOptions);
  }
}
```

Put inside **Runner**

```js
final runner = Runner(
  extensions: [
    const FirebaseCoreExtension(),
  ],
);

Future<void> main() => runner.run();
```
