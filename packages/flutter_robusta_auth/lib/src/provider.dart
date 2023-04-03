import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/src/access.dart';
import 'package:flutter_robusta_auth/src/auth.dart';
import 'package:flutter_robusta_auth/src/user.dart';

const _unimplementedErrorMsg =
    'Outside of FlutterAuthExtension, this provider not implemented.';

/// Providing auth manager to manage authentication.
final authManagerProvider = Provider<AuthManager>(
  (ref) => throw UnimplementedError(_unimplementedErrorMsg),
);

/// Providing user of app, use it to get manages current user.
final userProvider = Provider<User>(
  (_) => throw UnimplementedError(_unimplementedErrorMsg),
);

/// Providing access control to manage authorization.
final accessControlProvider = Provider<AccessControl>(
  (_) => throw UnimplementedError(_unimplementedErrorMsg),
);

/// Providing access definition to define ability.
final accessDefinitionProvider = Provider<AccessDefinition>(
  (_) => throw UnimplementedError(_unimplementedErrorMsg),
);
