import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_hive_auth/flutter_robusta_hive_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('providers', () {
    final container = ProviderContainer();

    test('using provider outside of runner', () {
      expect(
        () => container.read(credentialsHiveStorageProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
