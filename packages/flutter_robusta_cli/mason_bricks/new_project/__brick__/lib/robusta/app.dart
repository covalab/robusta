import 'package:flutter/material.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:{{project_name}}/presentation/screens/counter/screen.dart';

FlutterAppExtension appExtension() {
  return FlutterAppExtension(
    materialAppSettings: MaterialAppSettings(
      theme: ThemeData(),
    ),
    routerSettings: RouterSettings(
      screenFactories: [
        (c) => CounterScreen(),
      ],
    ),
  );
}
