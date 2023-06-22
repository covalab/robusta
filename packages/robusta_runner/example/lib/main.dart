import 'package:robusta_runner/robusta_runner.dart';

Future<void> main() async {
  var counter = 0;

  EventExtension eventExtension() {
    return EventExtension(
      configurator: (eventManager, container) {
        eventManager.addEventListener<RunEvent>((_) => counter++);
      },
    );
  }

  final runner = Runner(
    extensions: [eventExtension],
  );

  await runner.run();

  print(counter);
}
