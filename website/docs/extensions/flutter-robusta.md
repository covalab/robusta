---
id: flutter-robusta
title: Flutter Robusta
sidebar_position: 5
---

### Prerequites 📝

### Installing ⚙️

### Usage

Create the runner and use Material/Cupertino to run your app

```js
import 'package:flutter/material.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:go_router_plus/go_router_plus.dart';

class HomeScreen extends Screen implements InitialScreen {
  @override
  Center build(BuildContext context, GoRouterState state) {
    return const Center(
      child: Text('Home Screen'),
    );
  }

  @override
  String get routeName => 'home';

  @override
  String get routePath => '/home';
}

final runner = Runner(
  extensions: [
    ImplementingCallbackExtension(),
    FlutterAppExtension(
      routerSettings: RouterSettings(
        screenFactories: [
          (_) => HomeScreen(),
        ],
      ),
    ),
  ],
);


Future<void> main() => runner.run();
```

### API
