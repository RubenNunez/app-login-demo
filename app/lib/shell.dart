import 'package:app/modules/login/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class RootShell extends ConsumerWidget {
  const RootShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          // A common pattern when using bottom navigation bars is to support navigating
          // back to the initial location when tapping the item that is  already active.
          final popToRoot = index == navigationShell.currentIndex;
          navigationShell.goBranch(index, initialLocation: popToRoot);
          ref.read(currentTabProvider.notifier).state = index;
        },
      ),
      appBar: AppBar(
        title: const Text('App Login Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              // Navigation will be handled automatically by the router redirect
            },
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}
