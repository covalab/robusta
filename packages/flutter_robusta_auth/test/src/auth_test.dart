import 'dart:math';

import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('credentials memory storage', () {
    test('can initialize', () {
      expect(CredentialsMemoryStorage.new, returnsNormally);
    });

    test('storage behavior', () {
      final credentials = {'accessToken': 'test'};
      final storage = CredentialsMemoryStorage();

      expect(storage.read(), isNull);
      expect(() => storage.write(credentials), returnsNormally);
      expect(storage.read(), credentials);
      expect(storage.delete, returnsNormally);
      expect(storage.read(), isNull);
    });
  });

  group('auth manager', () {
    test('can initialize', () {
      expect(
        () => AuthManager(
          credentialsStorage: CredentialsMemoryStorage(),
          eventManager: DefaultEventManager(),
        ),
        returnsNormally,
      );
    });

    test('login behavior', () async {
      Map<String, String>? eventCredentials;
      final em = DefaultEventManager()
        ..addEventListener<LoggedInEvent>(
          (e) => eventCredentials = e.credentials,
        );

      final auth = AuthManager(
        credentialsStorage: CredentialsMemoryStorage(),
        eventManager: em,
      );

      final credentials = {'accessToken': 'test'};

      await expectLater(auth.loginByCrendentials(credentials), completes);

      expect(eventCredentials, equals(credentials));
      expect(await auth.currentCredentials, equals(credentials));

      await expectLater(
        auth.loginByCrendentials(credentials),
        throwsA(
          isA<AuthException>(),
        ),
      );
    });

    test('logout behavior', () async {
      Map<String, String>? eventCredentials;
      final em = DefaultEventManager()
        ..addEventListener<LoggedOutEvent>(
          (e) => eventCredentials = e.oldCredentials,
        );

      final auth = AuthManager(
        credentialsStorage: CredentialsMemoryStorage(),
        eventManager: em,
      );

      final credentials = {'accessToken': 'test'};

      await auth.loginByCrendentials(credentials);

      expect(await auth.currentCredentials, equals(credentials));

      await expectLater(auth.logout(), completes);

      expect(eventCredentials, equals(credentials));
      expect(await auth.currentCredentials, isNull);

      await expectLater(
        auth.logout(),
        throwsA(
          isA<AuthException>(),
        ),
      );
    });
  });
}
