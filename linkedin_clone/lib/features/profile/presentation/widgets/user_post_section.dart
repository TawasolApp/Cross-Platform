import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../feed/presentation/provider/feed_provider.dart';
import '../../presentation/provider/profile_provider.dart';
import 'user_post_card.dart';

class UserPostSection extends StatefulWidget {
  const UserPostSection({Key? key}) : super(key: key);

  @override
  State<UserPostSection> createState() => _UserPostSectionState();
}

class _UserPostSectionState extends State<UserPostSection> {
  bool _hasReset = false;
  bool _hasAttemptedLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasReset) {
        context.read<FeedProvider>().resetUserPosts();
        _hasReset = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    // Ensure we have loaded posts for this user
    if (feedProvider.userPosts.isEmpty && profileProvider.userId != null && !_hasAttemptedLoad) {
      feedProvider.fetchUserPosts(profileProvider.userId!, forceRefresh: true);
      _hasAttemptedLoad = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Activity",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
),
          const SizedBox(height: 10),
          
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth * 0.8;

              // Show loading indicator only if we're actively loading and haven't completed a load attempt
              if (feedProvider.isLoading && !_hasAttemptedLoad) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // Show empty state if posts are empty (regardless of loading state)
              // or we've already attempted to load posts
              if (feedProvider.userPosts.isEmpty) {
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No posts yet',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show posts if we have them
              return SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: feedProvider.userPosts.length.clamp(0, 4),
                  itemBuilder: (context, index) {
                    final post = feedProvider.userPosts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: SizedBox(
                        width: itemWidth,
                        child: UserPostCard(
                          post: post,
                          currentUserId: profileProvider.userId ?? '',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
