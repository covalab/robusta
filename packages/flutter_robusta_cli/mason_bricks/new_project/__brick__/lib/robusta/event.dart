import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:{{package_name}}/robusta/error_handle.dart';

EventExtension eventExtension() {
  return EventExtension(
    configurator: (em, container) {
      em.addEventListener<ErrorEvent>(onError);
    },
  );
}
