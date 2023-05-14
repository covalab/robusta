import 'package:flutter/material.dart';
import 'package:go_router_plus/go_router_plus.dart';

/// Handling router error, e.g: page not found.
class CustomErrorScreen extends Screen implements ErrorScreen {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _CustomErrorScreenWidget(
      error: state.error,
    );
  }

  @override
  String get routeName => 'custom_error';

  @override
  String get routePath => '/custom_error';
}

class _CustomErrorScreenWidget extends StatelessWidget {
  const _CustomErrorScreenWidget({required this.error, super.key});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robusta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Something went wrong!',
            ),
          ],
        ),
      ),
    );
  }
}
