part of './extension.dart';

/// Straties of asking notification permission
enum PermissionRequestStrategy {
  /// Request permission when booting
  init,

  /// Request permission later after boot
  later,

  /// User Logged in
  loggedIn,
}

/// {@template permission.settings}
///  Noti Permission Request Settings Obj.
/// {@endtemplate}
@sealed
class PermissionRequestSettings {
  /// {@macro permission_request_settings}
  const PermissionRequestSettings({
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
  Future<NotificationSettings> get currentSettings async =>
      FirebaseMessaging.instance.getNotificationSettings();
}

/// {@template permission.service}
///  Noti Permission Request Service Obj.
/// {@endtemplate}
@sealed
class PermissionRequestService {
  /// {@macro permission_request_service}
  const PermissionRequestService(
    PermissionRequestSettings? settings,
    EventManager manager,
  )   : _settings = settings ?? const PermissionRequestSettings(),
        _eventManager = manager;

  final PermissionRequestSettings _settings;
  final EventManager _eventManager;

  /// Request Notification Permission
  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: _settings._alert,
      announcement: _settings._announcement,
      badge: _settings._badge,
      carPlay: _settings._carPlay,
      criticalAlert: _settings._criticalAlert,
      provisional: _settings._provisional,
      sound: _settings._sound,
    );
  }
}
