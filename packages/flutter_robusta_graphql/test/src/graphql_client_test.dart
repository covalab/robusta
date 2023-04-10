import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  group('graphql client settings', () {
    test('can initialize', () {
      expect(
        () => GraphQLClientSettings(
          linkFactory: (c) => throw UnimplementedError(),
          cacheFactory: (c) => throw UnimplementedError(),
        ),
        returnsNormally,
      );
    });

    test('create instance with copyWith', () {
      var settings = GraphQLClientSettings(
        alwaysRebroadcast: true,
        linkFactory: (c) => throw UnimplementedError(),
        cacheFactory: (c) => throw UnimplementedError(),
      );

      settings = settings.copyWith(
        alwaysRebroadcast: false,
        linkFactory: (c) => Link.from([]),
      );

      expect(settings.linkFactory(ProviderContainer()), isA<Link>());

      expect(settings.alwaysRebroadcast, isFalse);

      expect(
        () => settings.cacheFactory(ProviderContainer()),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
