import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_robusta_auth/src/access.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('user', () {
    test('can initialize', () {
      expect(
        () => User(
          identityProvider: (_) => Identity(id: '1', data: {}),
          authManager: AuthManager(
            credentialsStorage: CredentialsMemoryStorage(),
            eventManager: DefaultEventManager(),
          ),
          eventManager: DefaultEventManager(),
          accessControl: AccessManager(),
        ),
        returnsNormally,
      );
    });

    test('can refresh user', () async {
      var identityChanged = false;
      final identityData = {'id': '1'};
      final em = DefaultEventManager()
        ..addEventListener<IdentityChangedEvent>((e) => identityChanged = true);
      final authManager = AuthManager(
        credentialsStorage: CredentialsMemoryStorage(),
        eventManager: em,
      );
      final user = User(
        identityProvider: (_) => Identity(id: identityData['id']!, data: {}),
        authManager: authManager,
        eventManager: em,
        accessControl: AccessManager(),
      );

      expect(user.currentIdentity, isNull);

      await expectLater(user.refreshIdentity(), completes);

      /// Refresh identity but not logged-in
      expect(user.currentIdentity, isNull);

      await authManager.loginByCrendentials({'access': 'token'});
      await expectLater(user.refreshIdentity(), completes);

      expect(identityChanged, isTrue);
      expect('1', user.currentIdentity!.id);

      identityData['id'] = 'changed';
      identityChanged = false;

      await expectLater(user.refreshIdentity(), completes);

      expect(identityChanged, isTrue);
      expect('changed', user.currentIdentity!.id);
    });
  });
}
