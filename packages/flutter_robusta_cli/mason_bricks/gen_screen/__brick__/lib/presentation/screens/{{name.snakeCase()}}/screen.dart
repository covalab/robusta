import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router_plus/go_router_plus.dart';

class {{name.pascalCase()}}Screen extends {{#use_shell}}Shell{{/use_shell}}Screen {
  @override
  Widget build(BuildContext context, GoRouterState state {{#use_shell}}, Widget child{{/use_shell}}) {
    return _{{name.pascalCase()}}ScreenWidget();
  }

  {{^use_shell}}
  @override
  String get routeName => '{{name.snakeCase()}}';
  {{/use_shell}}

  {{^use_shell}}
  @override
  String get routePath => '/{{name.paramCase()}}';
  {{/use_shell}}
}

class _{{name.pascalCase()}}ScreenWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text('{{name.titleCase()}} screen');
  }
}