// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:robusta_firebase_cloud_messaging/robusta_firebase_cloud_messaging.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_runner/robusta_runner.dart';

void main() {
  group('Firebase Cloud Messaging Extension', () {
    test('Cannot be used without FirebaseCoreExtension', () {
      expect(
        () => Runner(
          extensions: [
            FirebaseCloudMessagingExtension(
              eventManager: DefaultEventManager(),
            )
          ],
        ),
        throwsA(isA<RunnerException>()),
      );
    });

    test('Can be used with FirebaseCoreExtension initialized', () {
      final runner = Runner(
        extensions: [
          FirebaseCloudMessagingExtension(
            eventManager: DefaultEventManager(),
          ),
          FirebaseCoreExtension()
        ],
      );

      expectLater(() => runner.run, returnsNormally);
    });

    test('Get Message from Cloud Messaging', () async {
      // Assuming we have Notification Permission
      // Opt out [FirebaseMessaging.onMessage.listen(.....)]

      var remoteMessage = RemoteMessage();

      final em = DefaultEventManager();

      final mockRemoteMessage = RemoteMessage(data: {'test': 123});

      em
        ..addEventListener<OnMessageEventMock>(
          (mEvent) => remoteMessage = mEvent.rMessage,
        )
        ..dispatchEvent(
          OnMessageEventMock(mockRemoteMessage),
        );

      await expectLater(remoteMessage, equals(mockRemoteMessage));
    });
  });
}

class OnMessageEventMock extends Event {
  OnMessageEventMock(this.rMessage);

  RemoteMessage rMessage;
}
