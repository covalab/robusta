import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('provider', () {
    test(
      'cause error when read providers outside of FlutterGraphQLExtension',
      () {
        expect(
          () => ProviderContainer().read(graphQLClientProvider),
          throwsA(isA<UnimplementedError>()),
        );
      },
    );
  });
}
