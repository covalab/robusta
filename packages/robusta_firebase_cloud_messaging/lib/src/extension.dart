import 'dart:async';

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
    EventManager? eventManager,
    PermissionRequestSettings? settings,
    RequestStrategy? requestStrategy,
  })  : _eventManager = eventManager ?? DefaultEventManager(),
        _notiRequestStrategy = requestStrategy ?? RequestStrategy.init,
        _settings = settings ?? const PermissionRequestSettings();

  final EventManager _eventManager;
  final RequestStrategy _notiRequestStrategy;
  final PermissionRequestSettings _settings;

  @override
  FutureOr<void> load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 4095);
  }

  @override
  List<Type> dependsOn() => [FirebaseCoreExtension];

  Future<void> _boot(ProviderContainer container) async {
    if (_notiRequestStrategy == RequestStrategy.init) {
      await permissionRequest(container);
    }

    final messaging = FirebaseMessaging.instance;

    final notiAuthStatus = await messaging.getNotificationSettings();

    if (notiAuthStatus.authorizationStatus == AuthorizationStatus.authorized) {
      await _foregroundMessageHandler();
      await _backgroundMessageHandler();
    }
  }

  /// Foreground Message Handler
  Future<void> _foregroundMessageHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage rMessage) async {
      await _eventManager.dispatchEvent(OnMessageEvent._(rMessage));
    });
  }

  /// Background Message Handler
  Future<void> _backgroundMessageHandler() async {
    /// Messages come when app's in termniated state
    /// i.e: App is killed
    /// And [getInitialMessage] returns value when
    /// user taps on Notification
    final rInitialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (rInitialMessage != null) {
      _eventManager.dispatchEvent(OnBackgroundMessageEvent._(rInitialMessage));
    }

    /// Handle interaction when app is in background state
    /// and user taps on Notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage rMessage) {
      _eventManager.dispatchEvent(OnBackgroundMessageEvent._(rMessage));
    });

    /// When app is in background state and receiving Notification
    FirebaseMessaging.onBackgroundMessage((RemoteMessage rMessage) async {
      await _eventManager.dispatchEvent(OnBackgroundMessageEvent._(rMessage));
    });
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

    container.read(loggerProvider).i('User granted permission: $settings');
  }

  /// Subscribe to a topic in order to receive messages
  /// If any new messages released on the topic
  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  /// Unsubscribe to a topic
  /// No longer receives any messages on the subscribed topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
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

/// {@template firebase_cloud_messaging.on_background_message_event}
/// An event will be dispatch when background messages comes
/// from Firebase Cloud Messaging
/// {@endtemplate}
@sealed
class OnBackgroundMessageEvent extends Event {
  OnBackgroundMessageEvent._(this.rMessage);

  /// Message comes from Firebase Cloud Messaging
  RemoteMessage rMessage;
}
