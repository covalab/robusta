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
  })  : alert = alert ?? true,
        announcement = announcement ?? false,
        badge = badge ?? true,
        carPlay = carPlay ?? false,
        criticalAlert = criticalAlert ?? false,
        provisional = provisional ?? false,
        sound = sound ?? true;

  /// Request permission to display alerts. Defaults to `true`.
  ///
  /// iOS/macOS only.
  final bool alert;

  /// Request permission for Siri to automatically read out notification
  /// messages over AirPods.
  /// Defaults to `false`.
  ///
  /// iOS only.
  final bool announcement;

  /// Request permission to update the application badge. Defaults to `true`.
  ///
  /// iOS/macOS only.
  final bool badge;

  /// Request permission to display notifications in a CarPlay environment.
  /// Defaults to `false`.
  ///
  /// iOS only.
  final bool carPlay;

  /// Request permission for critical alerts. Defaults to `false`.
  ///
  /// Note; your application must explicitly state reasoning for enabling
  /// critical alerts during the App Store review process or your may be
  /// rejected.
  ///
  /// iOS only.
  final bool criticalAlert;

  /// Request permission to provisionally create non-interrupting notifications.
  /// Defaults to `false`.
  ///
  /// iOS only.
  final bool provisional;

  /// Request permission to play sounds. Defaults to `true`.
  ///
  /// iOS/macOS only.
  final bool sound;

  /// Get current Notification Settings
  // Future<NotificationSettings> get currentSettings async =>
  //     FirebaseMessaging.instance.getNotificationSettings();
}

/// {@template permission.service}
///  Noti Permission Request Service Obj.
/// {@endtemplate}
@sealed
class PermissionRequestService {
  /// {@macro permission_request_service}
  PermissionRequestService(
    PermissionRequestSettings? settings,
    FirebaseMessaging? messaging,
  )   : _settings = settings ?? const PermissionRequestSettings(),
        _messaging = messaging ?? FirebaseMessaging.instance;

  final PermissionRequestSettings _settings;
  final FirebaseMessaging _messaging;

  /// Request Notification Permission
  Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: _settings.alert,
      announcement: _settings.announcement,
      badge: _settings.badge,
      carPlay: _settings.carPlay,
      criticalAlert: _settings.criticalAlert,
      provisional: _settings.provisional,
      sound: _settings.sound,
    );
  }

  /// Get current [Permissiosn Request Settings]
  PermissionRequestSettings get settings => _settings;
}
