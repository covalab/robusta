import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/src/access.dart';
import 'package:flutter_robusta_auth/src/provider.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:go_router_plus/go_router_plus.dart';

/// Access redirector responsible to redirect user to [fallbackPath] when
/// user not have abilities to access screens.
class ScreenAccessControl implements Redirector {
  ScreenAccessControl(this.fallbackPath);

  final String _fallbackPath;

  final Pattern _pathPattern;

  final List<String> _abilities;

  final AccessController _controller;

  @override
  FutureOr<String?> redirect(
    Screen screen,
    BuildContext buildContext,
    GoRouterState state,
  ) async {
    if (_pathPattern.allMatches(state.location).isEmpty) {
      return null;
    }

    final results = await Future.wait(
      _abilities.map(
        (ability) async => _controller.check(screen.currentIdentity, ability),
      ),
    );

    return results.every((access) => access) ? null : _fallbackPath;
  }
}

/// Add ability to get current identity using app.
extension ScreenBaseX on ScreenBase {
  /// Current identity using app.
  Identity? get currentIdentity {
    final ctx = rootNavigatorKey.currentContext;

    if (null == ctx) {
      return null;
    }

    final user = ProviderScope.containerOf(ctx).read(userProvider);

    return user.currentIdentity;
  }
}
