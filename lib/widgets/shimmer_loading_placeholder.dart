import 'package:flutter/material.dart';

class ShimmerLoadingPlaceholder extends StatelessWidget {
  const ShimmerLoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
