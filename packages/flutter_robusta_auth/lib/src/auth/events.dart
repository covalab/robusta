part of '../auth.dart';

class _AuthEvent extends Event {
  _AuthEvent(this.identity);

  final Identity identity;
}

class LoginEvent extends _AuthEvent {
  LoginEvent(super.identity);
}

class LogoutEvent extends _AuthEvent {
  LogoutEvent(super.identity);
}
