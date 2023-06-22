// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:robusta_firebase_core/src/extension.dart';
import 'package:robusta_runner/robusta_runner.dart';

void main() {
  group('firebase core extension', () {
    test('can be instantiated', () {
      expect(FirebaseCoreExtension.new, returnsNormally);
    });

    test('calling firebase app with no extension provided', () async {
      EventExtension eventExtension() {
        return EventExtension(
          configurator: (em, c) {
            em.addEventListener<RunEvent>(
              (e) => expect(
                Firebase.app,
                throwsA(isA<FirebaseException>()),
              ),
            );
          },
        );
      }

      final runner = Runner(
        extensions: [eventExtension],
      );

      await runner.run();
    });
  });
}
