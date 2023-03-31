import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/src/provider.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:go_router_plus/go_router_plus.dart';

/// Access redirector responsible to redirect user
class ScreenAccessRedirector implements RestrictRedirector {
  ScreenAccessRedirector(this.fallbackPath);

  final String fallbackPath;

  @override
  bool shouldRedirect(Screen screen) {
    // TODO: implement shouldRedirect
    throw UnimplementedError();
  }

  @override
  FutureOr<String?> redirect(
    Screen screen,
    BuildContext buildContext,
    GoRouterState state,
  ) {
    // TODO: implement redirect
    throw UnimplementedError();
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
