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
    FirebaseMessaging? messaging,
    String? vapidKey,
    BackgroundMessageHandler? backgroundMessageHandler,
  })  : _requestStrategy = requestStrategy ?? PermissionRequestStrategy.init,
        _settings = settings ?? const PermissionRequestSettings(),
        _vapidKey = vapidKey,
        _messaging = messaging ?? FirebaseMessaging.instance,
        _backgroundMessageHandler = backgroundMessageHandler;

  final PermissionRequestStrategy _requestStrategy;
  final PermissionRequestSettings _settings;
  final FirebaseMessaging _messaging;
  final BackgroundMessageHandler? _backgroundMessageHandler;
  final String? _vapidKey;

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
    _messaging.onTokenRefresh.listen((token) {
      container.read(tokenProvider.notifier).state = token;
    });

    final manager = container.read(eventManagerProvider);

    /// This will get [Firebase Token] for the 1st boot
    /// Since token won't change unless it expires
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await _messaging.getToken(vapidKey: _vapidKey);

      container.read(tokenProvider.notifier).state = token;
      container.read(loggerProvider).d('Firebase Messaging Token: $token');

      if (_requestStrategy == PermissionRequestStrategy.init) {
        await _permissionRequest(container);
      }
    });

    if (_requestStrategy == PermissionRequestStrategy.loggedIn) {
      manager.addEventListener<LoggedInEvent>((event) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _permissionRequest(container);
        });
      });
    }

    await _listenerRegister(manager);
  }

  /// Request Notification Permission
  Future<void> _permissionRequest(ProviderContainer container) async {
    await container.read(permissionRequestServiceProvider).requestPermission();
  }

  Override _permissionOverride() {
    return permissionRequestServiceProvider.overrideWith((ref) {
      return PermissionRequestService(_settings, _messaging);
    });
  }

  /// Override Firebase Token
  Override _firebaseTokenOverride() {
    return tokenProvider.overrideWith((ref) => null);
  }

  Future<void> _listenerRegister(EventManager manager) async {
    /// App is Terminated, but there is a notification comes
    /// And user tap on incoming Notification,
    /// This will result starting application
    /// App is opened from Ternimated state
    final initMessage = await _messaging.getInitialMessage();

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
    if (_backgroundMessageHandler != null) {
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler!);
    }
  }
}

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
