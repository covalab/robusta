import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
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
  FirebaseMessagingExtension({
    PermissionRequestSettings? settings,
    PermissionRequestStrategy? requestStrategy,
    BackgroundMessageHandler backgroundMessageHandler = _bgMessageHandler,
  })  : _requestStrategy = requestStrategy ?? PermissionRequestStrategy.init,
        _settings = settings ?? const PermissionRequestSettings(),
        _backgroundMessageHandler = backgroundMessageHandler;

  final PermissionRequestStrategy _requestStrategy;
  final PermissionRequestSettings _settings;
  final BackgroundMessageHandler _backgroundMessageHandler;

  @override
  FutureOr<void> load(Configurator configurator) {
    configurator
      ..addContainerOverride(_permissionOverride())
      ..addContainerOverride(_firebaseTokenOverride())
      ..addBoot(_boot, priority: 4095);
  }

  @override
  List<Type> dependsOn() => [
        FirebaseCoreExtension,
        if (_requestStrategy == PermissionRequestStrategy.loggedIn)
          FlutterAuthExtension
      ];

  Future<void> _boot(ProviderContainer container) async {
    /// Register callback func onTokenRefresh
    /// to notify if token is changed and update value
    /// to [FirebaseTokenProvider] state
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      container.read(firebaseTokenProvider.notifier).state = token;
    });

    /// This will get [Firebase Token] for the 1st boot
    /// Since token won't change unless it expires
    final token = await FirebaseMessaging.instance.getToken();

    container.read(firebaseTokenProvider.notifier).state = token;
    container.read(loggerProvider).d('Firebase Messaging Token: $token');

    if (_requestStrategy == PermissionRequestStrategy.init) {
      await _permissionRequest(container);
    }

    if (_requestStrategy == PermissionRequestStrategy.loggedIn) {
      final isLoggedIn = await container.read(authManagerProvider).loggedIn;

      if (isLoggedIn) {
        await _permissionRequest(container);
      }
    }

    final manager = container.read(eventManagerProvider);

    await _listenerRegister(manager);
  }

  /// Request Notification Permission
  Future<void> _permissionRequest(ProviderContainer container) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await container
          .read(firebaseMessagingPermissionProvider)
          .requestPermission();
    });
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
    return firebaseMessagingPermissionProvider.overrideWith((ref) {
      final manager = ref.read(eventManagerProvider);
      return PermissionRequestService(_settings, manager);
    });
  }

  /// Override Firebase Token
  Override _firebaseTokenOverride() {
    return firebaseTokenProvider.overrideWith((ref) => null);
  }

  Future<void> _listenerRegister(EventManager manager) async {
    /// App is Terminated, but there is a notification comes
    /// And user tap on incoming Notification,
    /// This will result starting application
    /// App is opened from Ternimated state
    final initMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initMessage != null) {
      manager.dispatchEvent(
        OnMessageEvent.initMessage(initMessage),
      );
    }

    // /// Handle interaction when app is in background state
    // /// and user taps on Notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      manager.dispatchEvent(
        OnMessageEvent.messageOpenedApp(message),
      );
    });

    /// App is on Foreground and Messages/Notifications come
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      manager.dispatchEvent(
        OnMessageEvent.foreground(message),
      );
    });

    /// Register background messaging handler
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }
}

@pragma('vm:entry-point')
Future<void> _bgMessageHandler(RemoteMessage message) async {}

/// {@template firebase_messaging.on_message_event}
/// An event will be dispatch when messages comes from Firebase Cloud Messaging
/// {@endtemplate}
@sealed
class OnMessageEvent extends Event {
  OnMessageEvent._(this.message, this.source);

  /// Factory background OnMessageEvent
  factory OnMessageEvent.background(RemoteMessage message) =>
      OnMessageEvent._(message, OnMessageSource.background);

  /// Factory foreground OnMessageEvent
  factory OnMessageEvent.foreground(RemoteMessage message) =>
      OnMessageEvent._(message, OnMessageSource.foregound);

  /// Factory initMessage OnMessageEvent
  factory OnMessageEvent.initMessage(RemoteMessage message) =>
      OnMessageEvent._(message, OnMessageSource.initialMessage);

  /// Factory messageOpenedApp OnMessageEvent
  factory OnMessageEvent.messageOpenedApp(RemoteMessage message) =>
      OnMessageEvent._(message, OnMessageSource.messageOpenedApp);

  /// Message comes from Firebase Cloud Messaging
  RemoteMessage message;

  /// Source of Message
  OnMessageSource source;
}
