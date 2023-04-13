import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('throws exception when using providers outside runner', () {
    final container = ProviderContainer();

    test('access control', () {
      expect(
        () => container.read(accessControlProvider),
        throwsA(
          isA<UnimplementedError>(),
        ),
      );
    });

    test('access definition', () {
      expect(
        () => container.read(accessDefinitionProvider),
        throwsA(
          isA<UnimplementedError>(),
        ),
      );
    });

    test('user', () {
      expect(
        () => container.read(userProvider),
        throwsA(
          isA<UnimplementedError>(),
        ),
      );
    });

    test('auth manager', () {
      expect(
        () => container.read(authManagerProvider),
        throwsA(
          isA<UnimplementedError>(),
        ),
      );
    });
  });
}
