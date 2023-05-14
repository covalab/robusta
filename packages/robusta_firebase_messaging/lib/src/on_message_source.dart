part of 'extension.dart';

/// Sources of Remote Message
enum OnMessageSource {
  /// When app is on Foreground, message comes
  foregound,

  /// When app is at Background, message comes
  background,

  /// When app is terminated, message comes
  initialMessage,

  /// When app is opened from background state
  messageOpenedApp,
}
