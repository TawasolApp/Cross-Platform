import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/post_entity.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import '../../../profile/presentation/provider/profile_provider.dart';
import '../widgets/paginated_listview.dart';

class RepostsPage extends StatefulWidget {
  final String postId;

  const RepostsPage({super.key, required this.postId});

  @override
  State<RepostsPage> createState() => _RepostsPageState();
}

class _RepostsPageState extends State<RepostsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FeedProvider>(
        context,
        listen: false,
      ).fetchReposts(widget.postId);
      final profile = Provider.of<ProfileProvider>(context, listen: false);
      profile.fetchProfile("");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final myId = profileProvider.userId;

    return Scaffold(
      appBar: AppBar(title: const Text("Reposts")),
      body: PaginatedListView<PostEntity>(
        items: provider.reposts,
        isLoading: provider.isLoadingReposts,
        hasMore: provider.hasMoreReposts,
        errorMessage: provider.repostsError,
        onFetchMore: () => provider.fetchReposts(widget.postId),
        onRefresh: () => provider.fetchReposts(widget.postId, refresh: true),
        itemBuilder:
            (context, post, index) => PostCard(
              post: post,
              currentUserId: myId ?? '',
              profileImage: profileProvider.profilePicture,
              profileName: profileProvider.fullName,
              profileTitle: profileProvider.headline,
            ),
      ),
    );
  }
}
