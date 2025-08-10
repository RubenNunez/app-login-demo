import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 80, color: Colors.orange),
            Gap(24),
            Text(
              'More Options',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Gap(16),
            Text(
              'This is also a protected route.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Gap(8),
            Text(
              'Use the logout button in the app bar to sign out.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
