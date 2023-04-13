part of '../extension.dart';

/// Uses to define screen access control.
@sealed
class ScreenAccessDefinition {
  ScreenAccessDefinition._(this._accessControl);

  final AccessControl _accessControl;

  final List<ScreenAccessRedirector> _redirectors = [];

  /// Define screen access control with abilities have none arg to pass.
  void simpleDefine<AbilityArg>({
    required String pattern,
    required List<String> abilities,
    required String fallbackLocation,
    AccessDecisionStrategy strategy = AccessDecisionStrategy.any,
  }) {
    _redirectors.add(
      ScreenAccessRedirector(
        fallbackLocation: fallbackLocation,
        locationPattern: pattern,
        abilities: abilities
            .map((e) => ScreenAccessAbility<AbilityArg>(ability: e))
            .toList(),
        strategy: strategy,
        accessControl: _accessControl,
      ),
    );
  }

  /// Explicit define screen access control with list of [ScreenAccessAbility].
  void advanceDefine({
    required String pattern,
    required List<ScreenAccessAbility<dynamic>> abilities,
    required String fallbackLocation,
    AccessDecisionStrategy strategy = AccessDecisionStrategy.any,
  }) {
    _redirectors.add(
      ScreenAccessRedirector(
        fallbackLocation: fallbackLocation,
        locationPattern: pattern,
        abilities: abilities,
        strategy: strategy,
        accessControl: _accessControl,
      ),
    );
  }
}
