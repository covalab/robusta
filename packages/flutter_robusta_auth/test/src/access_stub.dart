import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';

class AccessDefiner {
  void call(AccessDefinition definition) {
    definition
      ..define('guest', (identity, [arg]) => null == identity)
      ..define('can-update-post', (p0, [arg]) => true)
      ..define('user', (identity, [arg]) => null != identity);
  }
}

class ScreenAccessDefiner {
  void call(ScreenAccessDefinition definition) {
    definition
      ..simpleDefine<void>(
        pattern: '^/guest',
        abilities: ['guest'],
        fallbackLocation: '/user',
      )
      ..simpleDefine<void>(
        pattern: '^/user',
        abilities: ['user'],
        fallbackLocation: '/guest',
      );
  }
}
