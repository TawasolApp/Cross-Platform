import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("News Feed"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body:
          feedProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : feedProvider.errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      feedProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        feedProvider.fetchPosts();
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: feedProvider.posts.length,
                itemBuilder: (context, index) {
                  final post = feedProvider.posts[index];
                  return PostCard(post: post);
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(RouteNames.createPost);
        },
        backgroundColor: Colors.blue,
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
