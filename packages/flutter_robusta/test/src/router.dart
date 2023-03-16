// ignore_for_file: prefer_const_constructors

import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_test/flutter_test.dart';

import 'stub.dart';

void main() {
  group('router', () {
    test('can initialize', () {
      expect(RouterSettings(), isNotNull);
    });

    test('can clone instance', () {
      final instance = RouterSettings(
        redirectLimit: 100,
        screenFactories: [
          (_) => TestScreen(),
        ],
      );
      final cloneInstance = instance.copyWith(
        screenFactories: [
          ...instance.screenFactories,
          (_) => TestScreen(),
        ],
      );

      expect(cloneInstance.redirectLimit, equals(100));
      expect(cloneInstance.screenFactories.length, equals(2));
    });
  });
}
