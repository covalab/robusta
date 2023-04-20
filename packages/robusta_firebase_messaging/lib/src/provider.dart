import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robusta_firebase_messaging/robusta_firebase_messaging.dart';

const _unimplementedErrorMsg =
    'Outside of FirebaseMessagingExtension, this provider not implemented.';

/// Provider accesses current Permission Request Settings
final firebaseMessagingPermissionProvider = Provider<PermissionRequestService>(
  (ref) => throw UnimplementedError(_unimplementedErrorMsg),
);

/// Provide state to access Firebase Token
final firebaseTokenProvider = StateProvider<String?>(
  (ref) => throw UnimplementedError(_unimplementedErrorMsg),
);
