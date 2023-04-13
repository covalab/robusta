import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_graphql/flutter_robusta_graphql.dart';

class Test with GraphQLClientSettable {}

final testProvider = Provider<Test>((_) => Test());
