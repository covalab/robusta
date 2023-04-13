import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';
import 'package:flutter_test/flutter_test.dart';

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

    test('constructor', () {
      final link = Link.from([]);
      final cache = GraphQLCache();
      final defaultPolicies = DefaultPolicies(query: Policies());
      final settings = GraphQLClientSettings(
        linkFactory: (c) => link,
        cacheFactory: (c) => cache,
        alwaysRebroadcast: true,
        defaultPolicies: defaultPolicies,
      );

      expect(settings.linkFactory(ProviderContainer()), link);
      expect(settings.cacheFactory(ProviderContainer()), cache);
      expect(settings.alwaysRebroadcast, isTrue);
      expect(settings.defaultPolicies, defaultPolicies);
    });
  });
}
