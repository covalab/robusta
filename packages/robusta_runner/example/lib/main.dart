import 'package:robusta_runner/robusta_runner.dart';

Future<void> main() async {
  var counter = 0;

  final runner = Runner(
    extensions: [
      EventExtension<RunEvent>(
        {
          (RunEvent e) => counter++: 0,
        },
      ),
    ],
  );

  await runner.run();

  print(counter);
}
