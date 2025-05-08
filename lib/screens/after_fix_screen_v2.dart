import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AfterFixScreenV2 extends StatefulWidget {
  const AfterFixScreenV2({super.key});

  @override
  State<AfterFixScreenV2> createState() => _AfterFixScreenV2State();
}

class _AfterFixScreenV2State extends State<AfterFixScreenV2>
    with AutomaticKeepAliveClientMixin {
  static const int _pageSize = 20;
  final List<String> _items = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 0;
  DateTime? _lastLoadTime;
  static const _throttleDuration = Duration(milliseconds: 500);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(_throttledScrollListener);

    // Pre-load next page images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadNextPageImages();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_throttledScrollListener);
    _scrollController.dispose();
    _clearImageCache();
    super.dispose();
  }

  void _clearImageCache() {
    // Clear the image cache for this page
    for (final url in _items) {
      CachedNetworkImage.evictFromCache(url);
    }
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  void _throttledScrollListener() {
    final now = DateTime.now();
    if (_lastLoadTime == null ||
        now.difference(_lastLoadTime!) > _throttleDuration) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _lastLoadTime = now;
        _loadMoreItems();
      }
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final newItems = List.generate(
        _pageSize,
        (i) =>
            'https://picsum.photos/id/${i + 10 + (_currentPage * _pageSize)}/200/300');

    if (mounted) {
      setState(() {
        _items.addAll(newItems);
        _currentPage++;
        _isLoading = false;
      });

      _preloadNextPageImages();
    }
  }

  void _preloadNextPageImages() {
    if (!mounted) return;

    final nextPageItems = List.generate(
        _pageSize,
        (i) =>
            'https://picsum.photos/id/${i + 10 + (_currentPage * _pageSize)}/200/300');

    for (final url in nextPageItems) {
      precacheImage(NetworkImage(url), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        title: const Text('After Fix V2'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            _preloadNextPageImages();
          }
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          cacheExtent: 500,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _items.length + 1,
          itemBuilder: (context, index) {
            if (index >= _items.length) {
              return _isLoading ? _buildLoadingIndicator() : null;
            }
            return _buildListItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    final url = _items[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedContainer(
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
                errorWidget: (context, _, __) => _buildErrorWidget(url, index),
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget(String url, int index) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.error, size: 50, color: Colors.red),
        onPressed: () {
          CachedNetworkImage.evictFromCache(url);
          setState(() {
            _items[index] = url;
          });
        },
      ),
    );
  }
}
