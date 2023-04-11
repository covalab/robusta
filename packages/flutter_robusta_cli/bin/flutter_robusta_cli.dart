import 'package:flutter_robusta_cli/flutter_robusta_cli.dart';
import 'package:logger/logger.dart';
import 'package:robusta_runner/robusta_runner.dart';

Future<void> main(List<String> arguments) async {
  final runner = Runner(
    logger: Logger(
      level: Level.info,
      filter: ProductionFilter(),
      printer: PrettyPrinter(
        noBoxingByDefault: true,
        errorMethodCount: 0,
        methodCount: 0,
      ),
    ),
    extensions: [
      ImplementingCallbackExtension(),
      EventExtension(
        configurator: (em, c) {
          em.addEventListener<RunEvent>(RunListener(arguments).call);
        },
      ),
    ],
  );

  await runner.run();
}
