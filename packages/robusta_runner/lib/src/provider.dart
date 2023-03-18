import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:robusta_events/robusta_events.dart';

/// Event manager provider
final eventManagerProvider = Provider<EventManager>(
  (_) => throw UnimplementedError(
    'Run your app with runner to initial this provider',
  ),
);

/// Logger provider
final loggerProvider = Provider<Logger>(
  (_) => throw UnimplementedError(
    'Run your app with runner to initial this provider',
  ),
);
