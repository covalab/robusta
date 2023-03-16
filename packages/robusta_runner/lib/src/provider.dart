import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:robusta_events/robusta_events.dart';

/// Event manager provider
final eventManagerProvider = Provider<EventManager>(
  (_) => throw UnimplementedError('Do you forgot to add event extension?'),
);

/// Logger provider
final loggerProvider = Provider<Logger>(
  (_) => throw UnimplementedError('Do you forgot to add logger extension?'),
);
