import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robusta_firebase_messaging/robusta_firebase_messaging.dart';

const _unimplementedErrorMsg = 'Permission has not granted, \n'
    'did you forget to request Notification Permission?';

/// Provider accesses current Permission Request Settings
final firebaseMessagingPermissionProvider = Provider<PermissionRequestSettings>(
  (ref) => throw UnimplementedError(_unimplementedErrorMsg),
);
