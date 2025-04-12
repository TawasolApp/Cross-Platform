import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import 'create_post_page.dart';

class UserFeedPage extends StatefulWidget {
  final String userId;

  const UserFeedPage({super.key, required this.userId});
  @override
  _UserFeedPageState createState() => _UserFeedPageState();
}

class _UserFeedPageState extends State<UserFeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      if (feedProvider.posts.isEmpty) {
        feedProvider.fetchUserPosts(widget.userId);
      }
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
              : ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: feedProvider.posts.length,
                itemBuilder: (context, index) {
                  final post = feedProvider.posts[index];
                  return PostCard(post: post);
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostCreationPage()),
          );
          if (result == true) {
            final feedProvider = Provider.of<FeedProvider>(
              context,
              listen: false,
            );
            await feedProvider.fetchUserPosts(widget.userId);
          }
        },
        backgroundColor: Colors.white,
        tooltip: 'Create Post',
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}