// ignore_for_file: prefer_const_constructors
import 'package:dio/dio.dart';
import 'package:test/test.dart';

import 'stub.dart';

void main() {
  group('dio settable', () {
    test('can initialize', () {
      expect(Repository.new, returnsNormally);
    });

    test('can set dio instance', () {
      final dio = Dio();
      final repo = Repository()..setDio(dio);

      expect(dio, equals(repo.dio));
    });
  });
}
