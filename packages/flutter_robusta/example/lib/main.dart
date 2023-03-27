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
    AppExtension(
      routerSettings: RouterSettings(
        screenFactories: [
          (_) => HomeScreen(),
        ],
      ),
    ),
  ],
);

Future<void> main() => runner.run();
