import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/src/access.dart';
import 'package:flutter_robusta_auth/src/provider.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:go_router_plus/go_router_plus.dart';

/// {@template screen.access_control}
/// Redirector with responsible to redirect user to [_fallbackPath] when
/// user not have abilities to access screens.
/// {@endtemplate}
class ScreenAccessControl<Arg> implements Redirector {
  /// {@macro screen.access_control}
  ScreenAccessControl({
    required String fallbackPath,
    required Pattern pathPattern,
    required AccessControl accessControl,
    required String ability,
    Arg? arg,
  })  : _fallbackPath = fallbackPath,
        _pathPattern = pathPattern,
        _accessControl = accessControl,
        _ability = ability,
        _arg = arg;

  final String _fallbackPath;

  final Pattern _pathPattern;

  final String _ability;

  final Arg? _arg;

  final AccessControl _accessControl;

  @override
  FutureOr<String?> redirect(
    Screen screen,
    BuildContext buildContext,
    GoRouterState state,
  ) async {
    if (_pathPattern.allMatches(state.location).isEmpty) {
      return null;
    }

    final canAccess = await _accessControl.check(
      screen.currentIdentity,
      _ability,
      _arg,
    );

    return canAccess ? null : _fallbackPath;
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
