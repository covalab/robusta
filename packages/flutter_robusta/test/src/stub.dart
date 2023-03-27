import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:go_router_plus/go_router_plus.dart';

final testState = StateProvider<String>((_) => 'Test State');

class TestExtension implements DependenceExtension {
  @override
  void load(Configurator configurator) {
    configurator.routerSettings.screenFactories.add((_) => TestScreen());
  }

  @override
  List<Type> dependsOn() => [AppExtension];
}

class TestScreen extends Screen implements InitialScreen {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final isCupertino = isCupertinoApp(context as Element);

    return Text(
      !isCupertino ? 'Material App' : 'Cupertino App',
      textDirection: TextDirection.ltr,
    );
  }

  @override
  String get routeName => 'test';

  @override
  String get routePath => '/test';

  /// Checks for MaterialApp in the widget tree.
  bool isCupertinoApp(Element elem) =>
      elem.findAncestorWidgetOfExactType<CupertinoApp>() != null;
}
