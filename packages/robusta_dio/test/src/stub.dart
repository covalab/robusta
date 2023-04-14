import 'package:riverpod/riverpod.dart';
import 'package:robusta_dio/robusta_dio.dart';

final repositoryProvider = Provider<Repository>((ref) => Repository());

class Repository with DioSettable {}
