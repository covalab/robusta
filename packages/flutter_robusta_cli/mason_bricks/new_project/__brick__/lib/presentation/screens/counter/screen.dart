import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:{{package_name}}/presentation/screens/counter/provider.dart';

class CounterScreen extends Screen implements InitialScreen {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _CounterScreenWidget();
  }

  @override
  String get routeName => 'counter';

  @override
  String get routePath => '/counter';
}

class _CounterScreenWidget extends ConsumerWidget {
  const _CounterScreenWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robusta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              ref.watch(counterStateProvider).toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterStateProvider.notifier).state++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
