import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../feed/domain/entities/post_entity.dart';
import '../../../feed/presentation/widgets/post_card.dart';
import '../../../feed/presentation/provider/feed_provider.dart';
import '../provider/admin_provider.dart';
import '../../../profile/presentation/provider/profile_provider.dart';

class PostAnalyticsPage extends StatefulWidget {
  const PostAnalyticsPage({super.key});

  @override
  State<PostAnalyticsPage> createState() => _PostAnalyticsPageState();
}

class _PostAnalyticsPageState extends State<PostAnalyticsPage> {
  PostEntity? topPost;
  PostEntity? mostReportedPost;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnalyticsPosts();
  }

  Future<void> _fetchAnalyticsPosts() async {
    final admin = Provider.of<AdminProvider>(context, listen: false);
    final feed = Provider.of<FeedProvider>(context, listen: false);
    final topId = admin.postAnalytics?.postWithMostInteractions;
    final reportedId = admin.postAnalytics?.mostReportedPost;

    PostEntity? fetchedTop;
    PostEntity? fetchedReported;

    if (topId != null) {
      fetchedTop = await feed.fetchPostById('68149f37a499ea16b390094f', topId);
    }
    if (reportedId != null) {
      fetchedReported = await feed.fetchPostById(
        '68149f37a499ea16b390094f',
        reportedId,
      );
    }

    setState(() {
      topPost = fetchedTop;
      mostReportedPost = fetchedReported;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);
    profile.fetchProfile(profile.userId ?? '');

    final postStats = admin.postAnalytics;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post Analytics",
          key: ValueKey('post_analytics_appbar_title'),
        ),
      ),
      body:
          postStats == null
              ? const Center(
                child: Text(
                  "No post analytics available.",
                  key: ValueKey('post_analytics_empty'),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatCard(
                      title: "Total Posts",
                      value: postStats.totalPosts.toString(),
                      icon: Icons.post_add,
                      color: Colors.green,
                      key: const ValueKey('post_analytics_stat_total_posts'),
                    ),
                    _buildStatCard(
                      title: "Total Comments",
                      value: postStats.totalComments.toString(),
                      icon: Icons.comment,
                      color: Colors.blueGrey,
                      key: const ValueKey('post_analytics_stat_total_comments'),
                    ),
                    _buildStatCard(
                      title: "Total Reactions",
                      value: postStats.totalReacts.toString(),
                      icon: Icons.thumb_up_alt,
                      color: Colors.deepOrange,
                      key: const ValueKey('post_analytics_stat_total_reacts'),
                    ),
                    _buildStatCard(
                      title: "Total Shares",
                      value: postStats.totalShares.toString(),
                      icon: Icons.share,
                      color: Colors.indigo,
                      key: const ValueKey('post_analytics_stat_total_shares'),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Post With Most Interactions:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      key: ValueKey('post_analytics_label_most_interacted'),
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const CircularProgressIndicator(
                        key: ValueKey('post_analytics_loading_top'),
                      )
                    else if (topPost != null)
                      PostCard(
                        key: const ValueKey('post_analytics_card_top_post'),
                        post: topPost!,
                        currentUserId: profile.userId ?? '',
                        profileImage: profile.profilePicture,
                        profileName: profile.fullName,
                        profileTitle: profile.headline ?? '',
                      )
                    else
                      const Text(
                        "Top post could not be loaded.",
                        key: ValueKey('post_analytics_top_post_error'),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      "Most Reported Post:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      key: ValueKey('post_analytics_label_most_reported'),
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const CircularProgressIndicator(
                        key: ValueKey('post_analytics_loading_reported'),
                      )
                    else if (mostReportedPost != null)
                      PostCard(
                        key: const ValueKey(
                          'post_analytics_card_most_reported',
                        ),
                        post: mostReportedPost!,
                        currentUserId: profile.userId ?? '',
                        profileImage: profile.profilePicture,
                        profileName: profile.fullName,
                        profileTitle: profile.headline ?? '',
                      )
                    else
                      const Text(
                        "Most reported post could not be loaded.",
                        key: ValueKey('post_analytics_reported_post_error'),
                      ),
                  ],
                ),
              ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    String? subtitle,
    Color color = Colors.blue,
    Key? key,
  }) {
    return Card(
      key: key,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(title, style: const TextStyle(fontSize: 14)),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
