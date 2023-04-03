import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('access manager', () {
    test('can initialize', () {
      expect(AccessManager.new, returnsNormally);
    });

    test('can define ability', () {
      final definition = AccessManager()
        ..define('test', (identity, [arg]) => false);
      expect(definition.has('test'), isTrue);
    });

    test('can check ability', () {
      final control = AccessManager()
        ..define('test', (identity, [arg]) => true);
      expect(control.has('test'), isTrue);
      expect(control.check(null, 'test'), isTrue);
    });

    test('can authorize ability', () async {
      final control = AccessManager()
        ..define('deny', (identity, [arg]) async => false)
        ..define('allows', (identity, [arg]) async => true);

      expect(control.has('deny'), isTrue);
      expect(control.has('allows'), isTrue);

      await expectLater(
        () async {
          await control.authorize(null, 'deny');
        },
        throwsA(isA<AccessException>()),
      );

      await expectLater(
        () async {
          await control.authorize(null, 'allows');
        },
        returnsNormally,
      );
    });

    test('can work with generic arg', () async {
      final control = AccessManager()
        ..define<bool>('bool', (identity, [arg]) => arg ?? false)
        ..define<String>('string', (identity, [arg]) async {
          if (arg == 'true') {
            return true;
          }

          return false;
        });

      expect(control.has('bool'), isTrue);
      expect(control.check(null, 'bool'), isFalse);
      expect(control.check(null, 'bool', false), isFalse);
      expect(control.check(null, 'bool', true), isTrue);
      expect(
        () => control.check(null, 'bool', ''),
        throwsA(isA<AccessException>()),
      );

      expect(control.has('string'), isTrue);
      expect(
        await control.check(null, 'string'),
        isFalse,
      );
      expect(
        await control.check(null, 'string', 'false'),
        isFalse,
      );
      expect(
        await control.check(null, 'string', 'true'),
        isTrue,
      );
      await expectLater(
        () async => control.check(null, 'string', true),
        throwsA(isA<AccessException>()),
      );
    });
  });
}
