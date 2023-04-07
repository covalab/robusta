import 'package:flutter/material.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'access_stub.dart';
import 'app_stub.dart';

void main() {
  group('flutter auth extension', () {
    test('can initialize', () {
      expect(
        () => FlutterAuthExtension(
          identityProvider: (_, __) => throw UnimplementedError(),
        ),
        returnsNormally,
      );
    });

    test('extension dependency', () {
      final extension = FlutterAuthExtension(
        identityProvider: (_, __) => throw UnimplementedError(),
      );

      expect(extension.dependsOn(), equals([FlutterAppExtension]));

      expect(
        () => Runner(
          extensions: [extension],
        ),
        throwsA(isA<RunnerException>()),
      );
    });

    testWidgets('providers had implemented when run', (tester) async {
      var canReadProviders = false;
      final runner = Runner(
        extensions: [
          FlutterAppExtension(routerSettings: RouterSettings()),
          FlutterAuthExtension(
            identityProvider: (_, __) => throw UnimplementedError(),
          ),
        ],
        defineBoot: (def) {
          def((c) {
            c
              ..read(authManagerProvider)
              ..read(userProvider)
              ..read(accessDefinitionProvider)
              ..read(accessControlProvider);
            canReadProviders = true;
          });
        },
      );

      await expectLater(runner.run(), completes);

      expect(canReadProviders, isTrue);
    });

    testWidgets('screen access control can work perfectly', (tester) async {
      final runner = Runner(
        extensions: [
          FlutterAppExtension(
            routerSettings: routerSettings,
          ),
          FlutterAuthExtension(
            identityProvider: (_, __) => Identity(id: '1', data: {}),
            defineAccess: AccessDefiner(),
            defineScreenAccess: ScreenAccessDefiner(),
          ),
        ],
      );

      await expectLater(runner.run(), completes);

      await tester.pumpAndSettle();

      expect(find.text('guest screen'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.login));

      await tester.pumpAndSettle();

      expect(find.text('user screen'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout));

      await tester.pumpAndSettle();

      expect(find.text('guest screen'), findsOneWidget);
    });

    testWidgets('widget rebuild when refresh identity', (tester) async {
      final data = {'id': '1'};

      final runner = Runner(
        extensions: [
          FlutterAppExtension(
            routerSettings: routerSettings,
          ),
          FlutterAuthExtension(
            identityProvider: (_, __) => Identity(id: data['id']!, data: data),
            defineAccess: AccessDefiner(),
            defineScreenAccess: ScreenAccessDefiner(),
          ),
        ],
      );

      await expectLater(runner.run(), completes);

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.login));

      await tester.pumpAndSettle();

      expect(find.text('user screen'), findsOneWidget);

      expect(find.text('User id: 1'), findsOneWidget);

      data['id'] = '2';

      await tester.tap(find.byIcon(Icons.refresh));

      await tester.pumpAndSettle();

      expect(find.text('User id: 2'), findsOneWidget);
    });
  });
}
