// features/feed/presentation/pages/feed_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_indicator.dart'; // Create this widget if missing

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FeedProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: () async => provider.loadPosts(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [SliverToBoxAdapter(child: _buildBodyContent(provider))],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBodyContent(FeedProvider provider) {
    if (provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: LoadingIndicator(),
      );
    }

    if (provider.error != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ErrorMessage(
          message: provider.error!.message,
          onRetry: () => provider.loadPosts(),
        ),
      );
    }

    if (provider.posts.isEmpty) {
      return const EmptyFeedMessage();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.posts.length,
      itemBuilder: (context, index) {
        final post = provider.posts[index];
        return PostCard(post: post);
      },
    );
  }
}

// Add these helper widgets at the bottom of the file
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorMessage({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message, style: TextStyle(color: Colors.red)),
        ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

class EmptyFeedMessage extends StatelessWidget {
  const EmptyFeedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No posts available. Start following people to see updates!'),
    );
  }
}
