import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Present for current user using app.
abstract class User {
  /// Identify of user
  String get id;

  /// Public information of user.
  Map<String, dynamic> get data => {};
}

/// Providing user by credentials given, exceptions MUST be throws in cases
/// invalid credentials or something went wrong can't provide user.
typedef UserProvider = FutureOr<User> Function(
  Map<String, String>,
  ProviderContainer,
);
