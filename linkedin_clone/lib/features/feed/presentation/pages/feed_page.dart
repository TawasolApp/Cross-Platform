import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import 'create_post_page.dart';
import '../../../profile/presentation/provider/profile_provider.dart';
import '../../../../core/services/token_service.dart';

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

      final profile = Provider.of<ProfileProvider>(context, listen: false);
      profile.fetchProfile("");
      if (feedProvider.posts.isEmpty) {
        feedProvider.fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);
    final myId = profile.userId;
    final profileImage = profile.profilePicture;
    final profileName = profile.fullName;
    final profileTitle = profile.headline;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Feed"),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
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
                  return PostCard(post: post, currentUserId: myId ?? '');
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PostCreationPage(
                    authorImage: profileImage,
                    authorName: profileName,
                    authorTitle: profileTitle,
                  ),
            ),
          );
          if (result == true) {
            final feedProvider = Provider.of<FeedProvider>(
              context,
              listen: false,
            );
            await feedProvider.fetchPosts();
          }
        },
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        tooltip: 'Create Post',
        child: Icon(Icons.add, color: isDarkMode ? Colors.white : Colors.blue),
      ),
    );
  }
}
