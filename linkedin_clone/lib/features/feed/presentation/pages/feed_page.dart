import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

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
              ? Center(child: Text(feedProvider.errorMessage!))
              : ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: feedProvider.posts.length,
                itemBuilder: (context, index) {
                  final post = feedProvider.posts[index];

                  return PostCard(post: post);
                },
              ),
      //Floating Action Button to Create Post
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
