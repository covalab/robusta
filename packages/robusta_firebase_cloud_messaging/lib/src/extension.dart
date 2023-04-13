import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_runner/robusta_runner.dart';

part './permission_settings.dart';

/// {@template robusta_firebase_cloud_messaging}
/// A Helper class for Firebase Cloud Messaiging
/// {@endtemplate}
class FirebaseCloudMessagingExtension implements DependenceExtension {
  /// {@macro robusta_firebase_cloud_messaging}
  FirebaseCloudMessagingExtension({
    required EventManager eventManager,
    NotiPermissionRequestSettings? settings,
    NotiRequestStrategy? notiRequestStrategy,
  })  : _eventManager = eventManager,
        _notiRequestStrategy = notiRequestStrategy ?? NotiRequestStrategy.init,
        _settings = settings ?? const NotiPermissionRequestSettings();

  final EventManager _eventManager;
  final NotiRequestStrategy _notiRequestStrategy;
  final NotiPermissionRequestSettings _settings;

  @override
  FutureOr<void> load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 4095);
  }

  @override
  List<Type> dependsOn() => [FirebaseCoreExtension];

  Future<void> _boot(ProviderContainer container) async {
    if (_notiRequestStrategy == NotiRequestStrategy.init) {
      await permissionRequest(container);
    }

    final messaging = FirebaseMessaging.instance;

    final notiAuthStatus = await messaging.getNotificationSettings();

    if (notiAuthStatus.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage rMessage) async {
        _eventManager.dispatchEvent(OnMessageEvent._(rMessage));
      });
    }
  }

  /// Request Notification Permission
  Future<void> permissionRequest(ProviderContainer container) async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: _settings._alert,
      announcement: _settings._announcement,
      badge: _settings._badge,
      carPlay: _settings._carPlay,
      criticalAlert: _settings._criticalAlert,
      provisional: _settings._provisional,
      sound: _settings._sound,
    );

    log('User granted permission: $settings');
  }
}

/// {@template firebase_cloud_messaging.on_message_event}
/// An event will be dispatch when messages comes from Firebase Cloud Messaging
/// {@endtemplate}
@sealed
class OnMessageEvent extends Event {
  OnMessageEvent._(this.rMessage);

  /// Message comes from Firebase Cloud Messaging
  RemoteMessage rMessage;
}
