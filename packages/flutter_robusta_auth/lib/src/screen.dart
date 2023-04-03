import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/src/access.dart';
import 'package:flutter_robusta_auth/src/provider.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:go_router_plus/go_router_plus.dart';

/// Strategy to make decision base on list of access abilities
enum AccessDecisionStrategy {
  /// Just requires have one of abilities in list.
  any,

  /// Requires have all abilities in list.
  every;
}

/// {@template screen.access_redirector}
/// Responsible to redirect current identity to
/// [fallbackLocation] when not they not have abilities to access screen.
/// {@endtemplate}
class ScreenAccessRedirector implements Redirector {
  /// {@macro screen.access_redirector}
  ScreenAccessRedirector({
    required this.fallbackLocation,
    required this.locationPattern,
    required this.abilities,
    required this.strategy,
    required AccessControl accessControl,
  }) : _accessControl = accessControl;

  /// Location pattern, current location needs to match this pattern to
  /// apply checking access abilities.
  final String locationPattern;

  /// Access definitions uses to check current identity
  /// when screen location match [locationPattern].
  final List<ScreenAccessAbility<dynamic>> abilities;

  /// Strategy uses to make decision to redirect.
  final AccessDecisionStrategy strategy;

  final AccessControl _accessControl;

  /// Fallback location when current identity not have abilities to access
  /// screen.
  final String fallbackLocation;

  @override
  Future<String?> redirect(
    Screen screen,
    BuildContext buildContext,
    GoRouterState state,
  ) async {
    if (!RegExp(locationPattern).hasMatch(state.location)) {
      return null;
    }

    switch (strategy) {
      case AccessDecisionStrategy.any:
        for (final item in abilities) {
          final result = await item._checkWith(
            _accessControl,
            screen,
            state,
          );

          if (result) {
            return null;
          }
        }

        return fallbackLocation;
      case AccessDecisionStrategy.every:
        for (final item in abilities) {
          final result = await item._checkWith(
            _accessControl,
            screen,
            state,
          );

          if (!result) {
            return fallbackLocation;
          }
        }

        return null;
    }
  }
}

/// {@template screen.access_ability}
/// Describe screen access with given [ability] and [arg] belong with it.
/// {@endtemplate}
class ScreenAccessAbility<Arg> {
  /// {@macro screen.access_ability}
  ScreenAccessAbility({required this.ability, this.arg});

  /// Ability need to check
  final String ability;

  /// Arg of [ability] to put in [AccessControl.check]
  final Arg? arg;

  /// Check current identity have ability to access [screen].
  FutureOr<bool> _checkWith(
    AccessControl accessControl,
    ScreenBase screen,
    GoRouterState state,
  ) {
    if (Arg is GoRouterState && null == arg) {
      return accessControl.check(
        screen.currentIdentity,
        ability,
        state,
      );
    }

    return accessControl.check(screen.currentIdentity, ability, arg);
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
