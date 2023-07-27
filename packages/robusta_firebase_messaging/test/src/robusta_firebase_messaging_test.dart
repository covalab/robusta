import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_firebase_messaging/robusta_firebase_messaging.dart';
import 'package:robusta_firebase_messaging/src/provider.dart';
import 'package:robusta_runner/robusta_runner.dart';

import 'mocks/firebase_messaging_mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase Cloud Messaging Extension', () {
    test('Cannot be used without FirebaseCoreExtension', () async {
      setupFirebaseCoreMocks();

      await Firebase.initializeApp();

      expect(
        () => Runner(
          extensions: [FirebaseMessagingExtension.new],
        ).run(),
        throwsA(isA<RunnerException>()),
      );
    });

    test('Work with Firebase Messaging Extension', () async {
      const fakeToken = 'fake-token';
      const fakeTokenOnRefresh = 'fake-token-on-refresh';
      const initMessageData = {'initMessage': 'Test init Message'};

      final mockFirebaseMessaging = MockFirebaseMessaging();

      when(mockFirebaseMessaging.getInitialMessage()).thenAnswer(
        (_) => Future.value(
          const RemoteMessage(
            data: initMessageData,
          ),
        ),
      );

      when(mockFirebaseMessaging.onTokenRefresh).thenAnswer(
        (_) => Stream<String>.fromIterable(<String>[fakeTokenOnRefresh]),
      );

      when(mockFirebaseMessaging.getToken()).thenAnswer(
        (_) => Future.value(fakeToken),
      );

      setupFirebaseCoreMocks();

      await mockFirebaseMessaging.getToken();

      final changes = await mockFirebaseMessaging.onTokenRefresh.first;

      await mockFirebaseMessaging.getInitialMessage();

      FirebaseMessagingExtension messagingExtension() {
        return FirebaseMessagingExtension(
          messaging: mockFirebaseMessaging,
          requestStrategy: PermissionRequestStrategy.later,
        );
      }

      EventExtension eventExtension() {
        return EventExtension(
          configurator: (em, container) {
            em.addEventListener((OnMessageEvent event) {
              /// Compare token
              final token = container.read(tokenProvider.notifier).state;

              expect(token, isNotNull);
              expect(token, fakeToken);

              /// Compare token On Refresh
              expect(changes, fakeTokenOnRefresh);

              /// Check Permission
              final currentPermission =
                  container.read(permissionRequestServiceProvider);

              expect(
                currentPermission.settings.alert,
                isTrue,
              );

              /// Check initial message
              if (event.source == OnMessageSource.initialMessage) {
                expect(event.message.data, initMessageData);
              }
            });
          },
        );
      }

      final runner = Runner(
        extensions: [
          FirebaseCoreExtension.new,
          messagingExtension,
          eventExtension,
        ],
      );

      await expectLater(runner.run(), completes);
    });
  });
}
