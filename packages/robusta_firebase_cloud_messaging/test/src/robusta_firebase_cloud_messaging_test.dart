// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:robusta_firebase_cloud_messaging/robusta_firebase_cloud_messaging.dart';

void main() {
  group('RobustaFirebaseCloudMessaging', () {
    test('can be instantiated', () {
      expect(RobustaFirebaseCloudMessaging(), isNotNull);
    });
  });
}
