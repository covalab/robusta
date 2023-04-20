import 'package:flutter/material.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:{{package_name}}/presentation/screens/counter/screen.dart';
import 'package:{{package_name}}/presentation/screens/custom_error/screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

FlutterAppExtension appExtension() {
  return FlutterAppExtension(
    materialAppSettings: MaterialAppSettings(
      theme: ThemeData(),
    ),
    routerSettings: RouterSettings(
      navigatorKey: rootNavigatorKey,
      screenFactories: [
        (c) => CounterScreen(),
        (c) => CustomErrorScreen(),
      ],
    ),
  );
}
