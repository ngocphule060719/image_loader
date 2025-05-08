import 'package:flutter/material.dart';
import 'before_fix_screen.dart';
import 'after_fix_screen.dart';
import 'after_fix_screen_v2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BeforeFixScreen()),
                );
              },
              child: const Text('Before Fix'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AfterFixScreen()),
                );
              },
              child: const Text('After Fix'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AfterFixScreenV2()),
                );
              },
              child: const Text('After Fix V2 (Optimized)'),
            ),
          ],
        ),
      ),
    );
  }
}
