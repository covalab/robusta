part of './extension.dart';

/// Straties of asking notification permission
enum NotiRequestStrategy {
  /// Request permission when booting
  init,

  /// Request permission later after boot
  later,
}

/// {@template permission.settings}
///  Noti Permission Request Settings Obj.
/// {@endtemplate}
@sealed
class NotiPermissionRequestSettings {
  /// {@macro noti_permission_request_settings}
  const NotiPermissionRequestSettings({
    bool? alert,
    bool? announcement,
    bool? badge,
    bool? carPlay,
    bool? criticalAlert,
    bool? provisional,
    bool? sound,
  })  : _alert = alert ?? true,
        _announcement = announcement ?? false,
        _badge = badge ?? true,
        _carPlay = carPlay ?? false,
        _criticalAlert = criticalAlert ?? false,
        _provisional = provisional ?? false,
        _sound = sound ?? true;

  final bool _alert;
  final bool _announcement;
  final bool _badge;
  final bool _carPlay;
  final bool _criticalAlert;
  final bool _provisional;
  final bool _sound;

  /// Get current Notification Settings
  Future<NotificationSettings> get currentSettings =>
      FirebaseMessaging.instance.getNotificationSettings();
}
