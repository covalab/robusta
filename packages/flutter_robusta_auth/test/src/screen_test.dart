import 'package:flutter/material.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_robusta_auth/src/access.dart';
import 'package:flutter_robusta_auth/src/screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'app_stub.dart';
import 'mocks/mocks.mocks.dart';

void main() {
  group('screen access redirector', () {
    test('can initialize', () {
      expect(
        () => ScreenAccessRedirector(
          fallbackLocation: '',
          locationPattern: '',
          abilities: [],
          strategy: AccessDecisionStrategy.any,
          accessControl: AccessManager(),
        ),
        returnsNormally,
      );
    });

    testWidgets('can work with any strategy', (tester) async {
      final accessManager = AccessManager()
        ..define('editor', (_, [__]) => true)
        ..define('manager', (_, [__]) => true);

      final runner = Runner(
        extensions: [
          FlutterAuthExtension(
            identityProvider: (_, __) => Identity(id: '1', data: {}),
          ),
          FlutterAppExtension(
            routerSettings: routerSettings.copyWith(
              refreshNotifierFactories: [
                (_) => accessManager,
              ],
              redirectorFactories: [
                (_) {
                  return ScreenAccessRedirector(
                    fallbackLocation: '/fallback',
                    locationPattern: '/guest',
                    abilities: [
                      ScreenAccessAbility(ability: 'editor'),
                      ScreenAccessAbility(ability: 'manager'),
                    ],
                    strategy: AccessDecisionStrategy.any,
                    accessControl: accessManager,
                  );
                }
              ],
            ),
          ),
        ],
      );

      await expectLater(runner.run(), completes);

      await tester.pumpAndSettle();

      expect(find.text('guest screen'), findsOneWidget);

      accessManager.define('editor', (_, [__]) => false);

      await tester.pumpAndSettle();

      expect(find.text('guest screen'), findsOneWidget);

      accessManager.define('manager', (_, [__]) => false);

      await tester.pumpAndSettle();

      expect(find.text('fallback screen'), findsOneWidget);
    });

    testWidgets('can work with every strategy', (tester) async {
      final accessManager = AccessManager()
        ..define('editor', (_, [__]) => true)
        ..define('manager', (_, [__]) => true);

      final runner = Runner(
        extensions: [
          FlutterAuthExtension(
            identityProvider: (_, __) => Identity(id: '1', data: {}),
          ),
          FlutterAppExtension(
            routerSettings: routerSettings.copyWith(
              refreshNotifierFactories: [
                (_) => accessManager,
              ],
              redirectorFactories: [
                (_) {
                  return ScreenAccessRedirector(
                    fallbackLocation: '/fallback',
                    locationPattern: '/guest',
                    abilities: [
                      ScreenAccessAbility(ability: 'editor'),
                      ScreenAccessAbility(ability: 'manager'),
                    ],
                    strategy: AccessDecisionStrategy.every,
                    accessControl: accessManager,
                  );
                }
              ],
            ),
          ),
        ],
      );

      await expectLater(runner.run(), completes);

      await tester.pumpAndSettle();

      expect(find.text('guest screen'), findsOneWidget);

      accessManager.define('editor', (_, [__]) => false);

      await tester.pumpAndSettle();

      expect(find.text('fallback screen'), findsOneWidget);
    });
  });

  group('screen access ability', () {
    test('can initialize', () {
      expect(
        () => ScreenAccessAbility<String>(ability: 'test', arg: 'test'),
        returnsNormally,
      );
    });

    test('can call check with', () {
      final accessManager = AccessManager()
        ..define('test', (p0, [arg]) => arg == 'test');
      final screenMock = MockScreen();
      when(screenMock.rootNavigatorKey).thenReturn(GlobalKey<NavigatorState>());
      final ability = ScreenAccessAbility<String>(ability: 'test', arg: 'test');

      expect(
        ability.checkWith(accessManager, screenMock, MockGoRouterState()),
        isTrue,
      );

      accessManager.define('test', (p0, [arg]) => arg != 'test');

      expect(
        ability.checkWith(accessManager, screenMock, MockGoRouterState()),
        isFalse,
      );
    });
  });
}
