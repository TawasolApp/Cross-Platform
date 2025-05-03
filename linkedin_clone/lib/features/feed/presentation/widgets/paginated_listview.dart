import 'package:flutter/material.dart';

class PaginatedListView<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final String? errorMessage;
  final Future<void> Function() onFetchMore;
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final String emptyMessage;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.errorMessage,
    required this.onFetchMore,
    required this.onRefresh,
    required this.itemBuilder,
    this.emptyMessage = "No items found",
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              hasMore &&
              !isLoading) {
            onFetchMore();
          }
          return false;
        },
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (items.isEmpty) {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (errorMessage != null) {
        return _buildError(context);
      } else {
        return _buildEmpty();
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length && hasMore) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return itemBuilder(context, items[index], index);
      },
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage ?? "An error occurred"),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRefresh, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(emptyMessage),
      ),
    );
  }
}
