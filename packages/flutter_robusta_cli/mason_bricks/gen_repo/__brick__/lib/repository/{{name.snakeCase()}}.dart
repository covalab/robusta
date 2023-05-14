import 'package:flutter_riverpod/flutter_riverpod.dart';
{{#use_dio}}import 'package:robusta_dio/robusta_dio.dart';{{/use_dio}}

{{^use_dio}}import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';{{/use_dio}}

final {{name.camelCase()}}RepositoryProvider = Provider<{{name.pascalCase()}}Repository>((ref) => {{name.pascalCase()}}Repository());

{{#use_dio}}class {{name.pascalCase()}}Repository with DioSettable { }{{/use_dio}}

{{^use_dio}}class {{name.pascalCase()}}Repository with GraphQLClientSettable { }{{/use_dio}}

