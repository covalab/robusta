---
id: robusta-runner
title: Robusta Runner
sidebar_position: 2
---

### Prerequites 📝

### Installing ⚙️

### Usage

```js
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

### API
