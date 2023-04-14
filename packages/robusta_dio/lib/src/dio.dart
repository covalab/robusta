import 'package:dio/dio.dart';

/// An interface to marks instances aware dio
// ignore: one_member_abstracts
abstract class DioAware {
  /// Method should be call after create instance.
  void setDio(Dio dio);
}

/// Support to quick implement [DioAware].
mixin DioSettable implements DioAware {
  /// Dio instance will be set when call [setDio].
  late Dio _dio;

  /// Providing [Dio] instance had set via [setDio].
  Dio get dio => _dio;

  @override
  void setDio(Dio dio) => _dio = dio;
}
