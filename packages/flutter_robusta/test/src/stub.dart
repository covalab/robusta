import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:go_router_plus/go_router_plus.dart';

final testState = StateProvider<String>((_) => 'Test State');

class TestExtension implements Extension {
  @override
  void load(Configurator configurator) {
    if (configurator.hasExtension<MaterialExtension>()) {
      final extension = configurator.getExtension<MaterialExtension>();
      extension.routerSettings.screenFactories.add((_) => TestScreen());
    }

    if (configurator.hasExtension<CupertinoExtension>()) {
      final extension = configurator.getExtension<CupertinoExtension>();
      extension.routerSettings.screenFactories.add((_) => TestScreen());
    }
  }
}

class TestScreen extends Screen implements InitialScreen {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Text(
      'Test Screen',
      textDirection: TextDirection.ltr,
    );
  }

  @override
  String get routeName => 'test';

  @override
  String get routePath => '/test';
}
