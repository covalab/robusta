import 'package:flutter_robusta_hive_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test app', () {
    testWidgets('can run app', (tester) async {
      await expectLater(runner.run, returnsNormally);
    });
  });
}
