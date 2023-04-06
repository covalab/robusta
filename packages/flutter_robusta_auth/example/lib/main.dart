import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';

final runner = Runner(
  extensions: [
    FlutterAppExtension(routerSettings: RouterSettings()),
    FlutterAuthExtension(
      defineAccess: (definition) {
        definition
          ..define('guest', (identity, [arg]) => null == identity)
          ..define('user', (identity, [arg]) => null != identity);
      },
      defineScreenAccess: (definition) {
        definition.simpleDefine(
          pattern: '/user',
          abilities: ['user'],
          fallbackLocation: '/guest',
        );
      },
      identityProvider: (credentials, container) => Identity(
        id: '1',
        data: {},
      ),
    ),
  ],
);

Future<void> main() => runner.run();
