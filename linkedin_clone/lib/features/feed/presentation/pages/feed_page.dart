import 'package:flutter/material.dart';
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
          Navigator.pushNamed(context, '/create-post');
        },
        backgroundColor: Colors.blue,
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
