import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:robusta_firebase_messaging/src/provider.dart';

void main() {
  group('Throw exception when using Provider outside Runner', () {
    final container = ProviderContainer();

    test('Permission Provider', () {
      expect(
        () => container.read(permissionRequestServiceProvider),
        throwsA(
          isA<UnimplementedError>(),
        ),
      );
    });

    test('Token Provider', () {
      expect(
        () => container.read(tokenProvider),
        throwsA(
          isA<UnimplementedError>(),
        ),
      );
    });
  });
}
