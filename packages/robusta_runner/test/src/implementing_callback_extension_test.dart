import 'package:riverpod/riverpod.dart';
import 'package:robusta_runner/robusta_runner.dart';
import 'package:test/test.dart';

import 'stub.dart';

void main() {
  group('implementing callback extension', () {
    test('can initialize', () async {
      expect(ImplementingCallbackExtension.new, returnsNormally);
    });

    test('can trigger callbacks added', () async {
      var counter = 0;
      final e = ImplementingCallbackExtension()
        ..addImplementingCallback(
          (Test t, ProviderContainer container) => counter++,
        );

      final runner = Runner(
        extensions: [e],
        boots: {
          (c) => c.read(testProvider): 0,
        },
      );

      await runner.run();

      expect(counter, equals(1));
    });
  });
}
