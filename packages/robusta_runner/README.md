Robusta Runner
--------------

Library help to run your awesome app, with it your application will easy-to-scale and maintain.

Installing
----------

Install this package via pub command:

```
dart pub get robusta_events
```

Usage
-----

Create the runner to run your app

```dart
import 'package:robusta_runner/robusta_runner.dart';

Future<void> main() async {
  var counter = 0;

  final runner = Runner(
    extensions: [
      EventExtension(
        configurator: (eventManager, container) {
          eventManager.addEventListener<RunEvent>((_) => counter++);
        },
      ),
    ],
  );

  await runner.run();

  print(counter);
}
```