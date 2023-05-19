---
id: robusta-firebase-core
title: Robusta Firebase Core
sidebar_position: 10
---

Initialize **[Firebase Core](https://firebase.flutter.dev/docs/core/usage/)** package through **Firebase Core Extension**

### Prerequites 📝

- Firebase configuration must be done with the help of **[FlutterFire CLI](https://firebase.flutter.dev/docs/overview)**.

### Installing ⚙️

### Usage

```js
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';

final runner = Runner(
  extensions: [
    // ...
    const FirebaseCoreExtension(),
  ],
);

Future<void> main() => runner.run();
```

### API
