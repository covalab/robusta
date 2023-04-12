// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('material settings', () {
    test('can initialize', () {
      expect(MaterialAppSettings(), isNotNull);
    });

    test('can clone instance', () {
      final instance = MaterialAppSettings(
        color: Color.fromRGBO(0, 0, 0, 0),
        supportedLocales: [Locale('VI')],
      );
      final cloneInstance = instance.copyWith(
        supportedLocales: [...instance.supportedLocales, Locale('US')],
      );

      expect(cloneInstance.supportedLocales, [Locale('VI'), Locale('US')]);
      expect(cloneInstance.color, Color.fromRGBO(0, 0, 0, 0));
    });
  });
}
