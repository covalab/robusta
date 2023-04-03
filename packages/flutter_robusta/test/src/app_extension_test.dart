import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_test/flutter_test.dart';

import 'stub.dart';

void main() {
  group('material extension', () {
    test('can initialize', () {
      expect(FlutterAppExtension(routerSettings: RouterSettings()), isNotNull);
    });

    testWidgets('can boot and run default Material app', (tester) async {
      final runner = Runner(
        extensions: [
          TestExtension(),
          FlutterAppExtension(routerSettings: RouterSettings()),
        ],
      );

      await runner.run();

      await tester.pump();

      expect(find.text('Material App'), findsOneWidget);
    });

    testWidgets('can boot and run Cupertino App', (tester) async {
      final runner = Runner(
        extensions: [
          TestExtension(),
          FlutterAppExtension(
            cupertinoAppSettings: CupertinoAppSettings(),
            routerSettings: RouterSettings(),
          ),
        ],
      );

      await runner.run();

      await tester.pump();

      expect(find.text('Cupertino App'), findsOneWidget);
    });

    testWidgets('can add app wrapper', (tester) async {
      final runner = Runner(
        extensions: [
          TestExtension(),
          FlutterAppExtension(
            routerSettings: RouterSettings(),
            wrappers: {
              (widget) =>
                  const Text('Wrapped', textDirection: TextDirection.ltr): 0,
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
          FlutterAppExtension(
            routerSettings: RouterSettings(),
            wrappers: {
              (widget) {
                return Consumer(
                  builder: (ctx, ref, child) {
                    return Text(
                      ref.read(testState),
                      textDirection: TextDirection.ltr,
                    );
                  },
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
