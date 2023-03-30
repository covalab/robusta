import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/src/auth.dart';
import 'package:flutter_robusta_auth/src/user.dart';

const _unimplementedErrorMsg =
    'Outside of FlutterAuthExtension, this provider not implemented.';

/// Providing auth manager of app, use it to access auth features.
final authManagerProvider = Provider<AuthManager>(
  (ref) => throw UnimplementedError(_unimplementedErrorMsg),
);

/// Providing user of app, use it to get manages current user.
final userProvider = Provider<User>(
  (_) => throw UnimplementedError(_unimplementedErrorMsg),
);
