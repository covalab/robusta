import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:robusta_firebase_core/robusta_firebase_core.dart';
import 'package:robusta_firebase_messaging/src/provider.dart';
import 'package:robusta_runner/robusta_runner.dart';

part 'permission_settings.dart';
part 'on_message_source.dart';

/// {@template robusta_firebase_messaging}
/// A Helper class for Firebase Cloud Messaiging
/// {@endtemplate}
class FirebaseMessagingExtension implements DependenceExtension {
  /// {@macro robusta_firebase_messaging}
  const FirebaseMessagingExtension({
    PermissionRequestSettings? settings,
    PermissionRequestStrategy? requestStrategy,
  })  : _notiRequestStrategy =
            requestStrategy ?? PermissionRequestStrategy.init,
        _settings = settings ?? const PermissionRequestSettings();

  final PermissionRequestStrategy _notiRequestStrategy;
  final PermissionRequestSettings _settings;

  @override
  FutureOr<void> load(Configurator configurator) {
    configurator.addBoot(_boot, priority: 4095);
  }

  @override
  List<Type> dependsOn() => [FirebaseCoreExtension];

  Future<void> _boot(ProviderContainer container) async {
    if (_notiRequestStrategy == PermissionRequestStrategy.init) {
      await permissionRequest(container);
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

    container.read(loggerProvider).i('User granted permission: $settings');

    await _listenerRegister(container);

    _permissionOverride();
  }

  Future<void> _listenerRegister(ProviderContainer container) async {
    final notiAuthStatus = await _settings.currentSettings;

    // TODO(qu0cquyen):  Hold background message Handler

    if (notiAuthStatus.authorizationStatus == AuthorizationStatus.authorized) {
      /// App is Terminated, but there is a notification comes
      /// And user tap on incoming Notification,
      /// This will result starting application
      /// App is opened from Ternimated state
      final rMessage = await FirebaseMessaging.instance.getInitialMessage();

      if (rMessage != null) {
        container.read(eventManagerProvider).dispatchEvent(
              OnMessageEvent._(rMessage, OnMessageSource.initialMessage),
            );
      }

      /// Handle interaction when app is in background state
      /// and user taps on Notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage rMessage) {
        container.read(eventManagerProvider).dispatchEvent(
              OnMessageEvent._(rMessage, OnMessageSource.messageOpenedApp),
            );
      });

      /// App is on Foreground and Messages/Notifications come
      FirebaseMessaging.onMessage.listen((RemoteMessage rMessage) {
        container.read(eventManagerProvider).dispatchEvent(
              OnMessageEvent._(rMessage, OnMessageSource.foregound),
            );
      });
    }
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

  Override _permissionOverride() {
    return firebaseMessagingPermissionProvider.overrideWithValue(_settings);
  }
}

/// {@template firebase_messaging.on_message_event}
/// An event will be dispatch when messages comes from Firebase Cloud Messaging
/// {@endtemplate}
@sealed
class OnMessageEvent extends Event {
  OnMessageEvent._(this.rMessage, this.source);

  /// Message comes from Firebase Cloud Messaging
  RemoteMessage rMessage;

  /// Source of Message
  OnMessageSource source;
}
