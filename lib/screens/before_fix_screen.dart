import 'package:flutter/material.dart';

class BeforeFixScreen extends StatelessWidget {
  const BeforeFixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items =
        List.generate(100, (i) => 'https://picsum.photos/id/${i + 10}/200/300');

    return Scaffold(
      appBar: AppBar(title: const Text('Before Fix')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                Image.network(items[index]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Item $index'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
