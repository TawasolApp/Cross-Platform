import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';

class SavedPostsPage extends StatefulWidget {
  final String userId;
  final String? profileImage;
  final String profileName;
  final String? profileTitle;
  const SavedPostsPage({
    super.key,
    required this.userId,
    this.profileImage,
    required this.profileName,
    this.profileTitle,
  });

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeedProvider>(context, listen: false).fetchSavedPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedProvider>(context);
    final posts = provider.savedPosts;
    final isLoading = provider.isLoading;
    final error = provider.errorMessage;

    return Scaffold(
      appBar: AppBar(title: const Text("Saved Posts")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error))
              : posts.isEmpty
              ? const Center(child: Text("No saved posts"))
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(
                    post: post,
                    currentUserId: widget.userId,
                    profileImage: widget.profileImage,
                    profileName: widget.profileName,
                    profileTitle: widget.profileTitle,
                  );
                },
              ),
    );
  }
}
