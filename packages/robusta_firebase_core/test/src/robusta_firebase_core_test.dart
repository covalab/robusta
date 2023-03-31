// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:robusta_firebase_core/src/extension.dart';
import 'package:robusta_runner/robusta_runner.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterRobustaFirebaseCore', () {
    test('can be instantiated', () {
      expect(() => FirebaseCoreExtension(), returnsNormally);
    });

    test('calling firebase app with no extension provided', () async {
      final runner = Runner(extensions: [
        EventExtension<RunEvent>({
          (e) => expect(
              () => Firebase.app(), throwsA(isA<FirebaseException>())): 0,
        }),
      ]);

      await runner.run();
    });
  });
}
