import 'dart:async';

import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:flutter_robusta_auth/src/user.dart';
import 'package:meta/meta.dart';

/// The callback to grain access permission for actions of current user
/// when return true otherwise actions should be deny.
typedef Rule<Arg> = FutureOr<bool> Function(Identity?, [Arg? arg]);

/// {@template access.rule}
/// [RuleResolver] identify.
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

/// Uses to define access ability.
@sealed
class AccessDefinition {
  final _abilities = <String, _RuleResolver<dynamic>>{};

  /// Whether added [ability] or not.
  bool has(String ability) => _abilities.containsKey(ability);

  /// Define rule use to checking access
  void define<Arg>(String ability, Rule<Arg> rule) {
    _abilities[ability] = _RuleResolver<Arg>(
      ability: ability,
      rule: rule,
    );
  }
}

/// Control access via abilities defined.
@sealed
class AccessControl with AccessDefinition {
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
