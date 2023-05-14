import 'package:mockito/annotations.dart';
import 'package:robusta_firebase_messaging/robusta_firebase_messaging.dart';

@GenerateNiceMocks(
  [MockSpec<FirebaseMessaging>(onMissingStub: OnMissingStub.returnDefault)],
)
void main() {}
