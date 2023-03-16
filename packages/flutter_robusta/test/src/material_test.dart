// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_test/flutter_test.dart';

import 'stub.dart';

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

  group('material extension', () {
    test('can initialize', () {
      expect(MaterialExtension(), isNotNull);
    });

    testWidgets('can boot and run apps', (tester) async {
      final runner = Runner(
        extensions: [
          TestExtension(),
          MaterialExtension(),
        ],
      );

      await runner.run();

      await tester.pump();

      expect(find.text('Test Screen'), findsOneWidget);
    });

    testWidgets('can add app wrapper', (tester) async {
      final runner = Runner(
        extensions: [
          TestExtension(),
          MaterialExtension(
            wrappers: {
              (widget) => Text('Wrapped', textDirection: TextDirection.ltr): 0,
            },
          ),
        ],
      );

      await runner.run();

      await tester.pump();

      expect(find.text('Wrapped'), findsOneWidget);
    });

    testWidgets('can use Riverpod features', (tester) async {
      final runner = Runner(
        extensions: [
          TestExtension(),
          MaterialExtension(
            wrappers: {
              (widget) {
                return Consumer(
                  builder: (_, ref, child) => Text(
                    ref.read(testState),
                    textDirection: TextDirection.ltr,
                  ),
                );
              }: 0,
            },
          ),
        ],
      );

      await runner.run();

      await tester.pump();

      expect(find.text('Test State'), findsOneWidget);
    });
  });
}
