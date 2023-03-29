import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/src/auth.dart';
import 'package:flutter_robusta_auth/src/user.dart';

final authManagerProvider = Provider<AuthManager>(
  (ref) => throw UnimplementedError(
    'Outside of FlutterAuthExtension, this provider not implemented.',
  ),
);

final currentUserProvider = StateProvider<User?>(
  (_) => throw UnimplementedError(
    'Outside of FlutterAuthExtension, this provider not implemented.',
  ),
);

final userFamily = Provider.family<FutureOr<User>, Map<String, String>>(
  (ref, credentials) async => throw UnimplementedError(
    'Outside of FlutterAuthExtension, this provider not implemented.',
  ),
);
