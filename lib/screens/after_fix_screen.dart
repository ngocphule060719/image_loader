import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AfterFixScreen extends StatelessWidget {
  const AfterFixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items =
        List.generate(100, (i) => 'https://picsum.photos/id/${i + 10}/200/300');

    return Scaffold(
      appBar: AppBar(title: const Text('After Fix')),
      body: ListView.builder(
        cacheExtent: 500,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final url = items[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: CachedNetworkImage(
                    key: ValueKey(url),
                    imageUrl: url,
                    placeholder: (context, _) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, _, __) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    memCacheWidth: 400,
                    memCacheHeight: 600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Item $index',
                    key: ValueKey('text_$index'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
