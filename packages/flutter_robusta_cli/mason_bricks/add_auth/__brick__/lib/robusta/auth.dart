import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:flutter_robusta_hive_auth/flutter_robusta_hive_auth.dart';

FlutterAuthExtension authExtension() {
  return FlutterAuthExtension(
    credentialsStorageFactory: (container) => container.read(
      credentialsHiveStorageProvider,
    ),
    identityProvider: (credentials, container) => throw UnimplementedError(),
    defineAccess: (def) {
      def.define<void>('guest', (identity, [arg]) => identity == null);
      def.define<void>('user', (identity, [arg]) => identity != null);
    },
    defineScreenAccess: (def) {
      /// Define your screen access logics
      /// ex:
      // def.simpleDefine(
      //   pattern: '^/guest',
      //   abilities: ['guest'],
      //   fallbackLocation: '/user?error_code=access_denied',
      // );
    },
  );
}
