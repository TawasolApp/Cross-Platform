import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import 'create_post_page.dart';
import '../../../profile/presentation/provider/profile_provider.dart';
import '../../../../core/services/token_service.dart';
import '../widgets/paginated_listview.dart';
import '../../domain/entities/post_entity.dart';

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
      body: PaginatedListView<PostEntity>(
        items: feedProvider.posts,
        isLoading: feedProvider.isLoading,
        hasMore: feedProvider.hasMorePosts,
        errorMessage: feedProvider.errorMessage,
        onFetchMore: () => feedProvider.fetchPosts(),
        onRefresh: () => feedProvider.fetchPosts(refresh: true),
        itemBuilder: (context, post, index) {
          // padding: const EdgeInsets.only(top: 10),
          //final post = feedProvider.posts[index];
          return PostCard(
            post: post,
            currentUserId: myId ?? '',
            profileImage: profile.profilePicture,
            profileName: profile.fullName,
            profileTitle: profile.headline,
          );
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
