import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:meta/meta.dart';

/// The callback to grain access permission for actions of current user
/// when return true otherwise actions should be deny.
typedef Rule<Arg> = FutureOr<bool> Function(Identity?, [Arg? arg]);

/// Strategy to make decision base on list of access abilities
enum AccessDecisionStrategy {
  /// Just requires have one of abilities in list.
  any,

  /// Requires have all abilities in list.
  every;
}

/// {@template access.rule}
/// [_RuleResolver] identify.
/// {@endtemplate}
class _RuleResolver<Arg> {
  /// {@macro access.rule}
  _RuleResolver({required this.ability, required this.rule});

  /// Ability present for rule.
  final String ability;

  /// Rule need to resolve.
  final Rule<Arg> rule;

  /// Whether given identity can pass the rule.
  FutureOr<bool> resolve(Identity? identity, [Object? arg]) {
    if (arg is Arg || null == arg) {
      return rule(identity, arg as Arg?);
    }

    throw AccessException.invalidRuleArgType(Arg, ability);
  }
}

/// Mapping ability name with it rule.
@internal
mixin AccessAbility on ChangeNotifier {
  final _abilities = <String, _RuleResolver<dynamic>>{};

  void _define<Arg>(String ability, Rule<Arg> rule) {
    _abilities[ability] = _RuleResolver<Arg>(
      ability: ability,
      rule: rule,
    );
    notifyListeners();
  }
}

/// Defines access [_abilities].
mixin AccessDefinition on AccessAbility {
  /// Whether added [ability] or not.
  bool has(String ability) => _abilities.containsKey(ability);

  /// Define rule use to checking access
  void define<Arg>(String ability, Rule<Arg> rule) {
    _define<Arg>(ability, rule);
  }
}

/// Control access based on [_abilities].
mixin AccessControl on AccessAbility {
  /// Allows given [identity] to access [ability] with [arg].
  /// If not an [AccessException.deny] will be throws.
  Future<void> authorize<Arg>(
    Identity? identity,
    String ability, [
    Arg? arg,
  ]) async {
    final authorized = await check(identity, ability, arg);

    if (!authorized) {
      throw AccessException.deny();
    }
  }

  /// Allows given [identity] to access [ability] with [arg].
  FutureOr<bool> check<Arg>(Identity? identity, String ability, [Arg? arg]) {
    if (null == _abilities[ability]) {
      return false;
    }

    return _abilities[ability]!.resolve(identity, arg);
  }
}

/// Manage app authorize logics.
@internal
class AccessManager
    with ChangeNotifier, AccessAbility, AccessDefinition, AccessControl {}
