import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';

FlutterAppExtension flutterAppExtension() {
  return FlutterAppExtension(routerSettings: RouterSettings());
}

FlutterAuthExtension flutterAuthExtension() {
  return FlutterAuthExtension(
    defineAccess: (definition) {
      definition
        ..define('guest', (identity, [arg]) => null == identity)
        ..define('user', (identity, [arg]) => null != identity);
    },
    defineScreenAccess: (definition) {
      definition.simpleDefine<void>(
        pattern: '/user',
        abilities: ['user'],
        fallbackLocation: '/guest',
      );
    },
    identityProvider: (credentials, container) => Identity(
      id: '1',
      data: {},
    ),
  );
}

final runner = Runner(
  extensions: [
    flutterAppExtension,
    flutterAuthExtension,
  ],
);

Future<void> main() => runner.run();
