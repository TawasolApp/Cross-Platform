import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/paginated_listview.dart';
import '../../domain/entities/post_entity.dart';

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
    // final posts = provider.savedPosts;
    // final isLoading = provider.isLoading;
    // final error = provider.errorMessage;

    return Scaffold(
      appBar: AppBar(title: const Text("Saved Posts")),
      body: PaginatedListView<PostEntity>(
        items: provider.savedPosts,
        isLoading: provider.isLoading,
        hasMore: provider.hasMoreSavedPosts,
        errorMessage: provider.errorMessage,
        onFetchMore: () => provider.fetchSavedPosts(),
        onRefresh: () => provider.fetchSavedPosts(refresh: true),
        itemBuilder:
            (context, post, index) => PostCard(
              post: post,
              currentUserId: widget.userId,
              profileImage: widget.profileImage,
              profileName: widget.profileName,
              profileTitle: widget.profileTitle,
            ),
      ),
    );
  }
}
