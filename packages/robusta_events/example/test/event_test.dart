import 'package:robusta_events_example/main.dart';
import 'package:test/test.dart';

void main() {
  group('test event', () {
    test('can increase counter', () {
      final e = TestEvent();
      eventManager.dispatchEvent(e);

      expect(e.counter, equals(1));

      eventManager.dispatchEvent(e);

      expect(e.counter, equals(2));
    });
  });
}
