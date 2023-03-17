import 'package:flutter_robusta_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test app', () {
    testWidgets('can run app', (tester) async {
      await runner.run();
      await tester.pump();

      expect(find.text('Home Screen'), findsOneWidget);
    });
  });
}
