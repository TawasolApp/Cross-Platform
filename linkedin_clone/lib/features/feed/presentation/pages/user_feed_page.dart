import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import 'create_post_page.dart';
import '../../../profile/presentation/provider/profile_provider.dart';

class UserFeedPage extends StatefulWidget {
  final String userId;
  final bool showFAB;

  const UserFeedPage({
    super.key,
    required this.userId,
    this.showFAB = true, // show button to create a post
  });

  @override
  _UserFeedPageState createState() => _UserFeedPageState();
}

class _UserFeedPageState extends State<UserFeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.fetchUserPosts(widget.userId);

      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      profileProvider.fetchProfile("");
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);
    final myId = profile.userId;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body:
          feedProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: feedProvider.userPosts.length,
                itemBuilder: (context, index) {
                  final post = feedProvider.userPosts[index];
                  return PostCard(
                    post: post,
                    currentUserId: myId ?? '',
                  ); ///////
                },
              ),
      floatingActionButton:
          widget.showFAB
              ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostCreationPage(),
                    ),
                  );
                  if (result == true) {
                    final feedProvider = Provider.of<FeedProvider>(
                      context,
                      listen: false,
                    );
                    await feedProvider.fetchUserPosts(widget.userId);
                  }
                },
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                tooltip: 'Create Post',
                child: Icon(
                  Icons.add,
                  color: isDarkMode ? Colors.white : Colors.blue,
                ),
              )
              : null,
    );
  }
}
