import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void defineBoot(BootDefinition def) {
  def(_boot);
}

Future<void> _boot(ProviderContainer container) async {
  final logger = container.read(loggerProvider);

  logger.i('Booting...');
}
