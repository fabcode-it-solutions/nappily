import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/features/auth/auth.dart';
import 'router_provider.dart';

class Routes extends ConsumerWidget {
  const Routes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final auth = ref.watch(authProvider);

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        if (child == null) throw Exception('No child in router builder');
        return AppAuthScope(notifier: auth, child: child);
      },
    );
  }
}
