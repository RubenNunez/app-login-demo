import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80, color: Colors.blue),
            Gap(24),
            Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Gap(16),
            Text(
              'This is a protected route.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Gap(8),
            Text(
              'You can only see this after logging in.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
