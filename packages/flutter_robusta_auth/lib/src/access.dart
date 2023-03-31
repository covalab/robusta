import 'package:flutter_robusta_auth/src/exception.dart';
import 'package:flutter_robusta_auth/src/user.dart';

/// The callback to grain access permission for actions of current user
/// when return true otherwise actions should be deny.
typedef Rule<Arg> = bool Function(Identity?, [Arg? arg]);

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
  bool resolve(Identity? identity, [Object? arg]) {
    if (arg is! Arg) {
      throw AccessException.invalidRuleArgType(arg.runtimeType, ability);
    }

    return rule(identity, arg);
  }
}

/// App access control by defined [Rule]s.
class AccessController {
  final _abilities = <String, _RuleResolver<dynamic>>{};

  /// Whether added [rule] or not.
  void has(String ability) => _abilities.containsKey(ability);

  /// Define rule use to checking access
  void define<Arg>(String ability, Rule<Arg> rule) {
    _abilities[ability] = _RuleResolver<Arg>(
      ability: ability,
      rule: rule,
    );
  }

  /// Allows given [identity] to access [ability] with [arg].
  /// If not an [AccessException.deny] will be throws.
  void authorize<Arg>(Identity? identity, String ability, [Arg? arg]) {
    if (!check(identity, ability, arg)) {
      throw AccessException.deny();
    }
  }

  /// Allows given [identity] to access [ability] with [arg].
  bool check<Arg>(Identity? identity, String ability, [Arg? arg]) {
    if (null == _abilities[ability]) {
      return false;
    }

    return _abilities[ability]!.resolve(identity, arg);
  }
}

