import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

const _unimplementedErrorMsg =
    'Outside of DioExtension, this provider not implemented.';

/// Providing dio instance
final dioProvider = Provider<Dio>(
  (ref) => throw UnimplementedError(_unimplementedErrorMsg),
);
