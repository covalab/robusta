import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_robusta/flutter_robusta.dart';
import 'package:flutter_robusta_auth/flutter_robusta_auth.dart';
import 'package:go_router_plus/go_router_plus.dart';

class FallbackScreen extends Screen {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Text('fallback screen');
  }

  @override
  String get routeName => 'fallback';

  @override
  String get routePath => '/fallback';
}

class UserScreen extends Screen {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Consumer(
      builder: (ctx, ref, child) {
        final identity = ref.watch(
          userProvider.select((i) => i.currentIdentity),
        );
        return Scaffold(
          body: Column(
            children: [
              const Text('user screen'),
              Text('User id: ${identity?.id}'),
            ],
          ),
          appBar: AppBar(
            actions: [
              ElevatedButton(
                onPressed: () => ref.read(userProvider).refreshIdentity(),
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: ref.read(authManagerProvider).logout,
            child: const Icon(Icons.logout),
          ),
        );
      },
    );
  }

  @override
  String get routeName => 'user';

  @override
  String get routePath => '/user';
}

class GuestScreen extends Screen implements InitialScreen {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Consumer(
      builder: (ctx, ref, child) {
        return Scaffold(
          body: const Text('guest screen'),
          floatingActionButton: FloatingActionButton(
            onPressed: () => ref.read(authManagerProvider).loginByCrendentials(
              {'accessToken': 'test'},
            ),
            child: const Icon(Icons.login),
          ),
        );
      },
    );
  }

  @override
  String get routeName => 'guest';

  @override
  String get routePath => '/guest';
}

final routerSettings = RouterSettings(
  screenFactories: [
    (_) => GuestScreen(),
    (_) => UserScreen(),
    (_) => FallbackScreen(),
  ],
);
