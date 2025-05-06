import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_post_card.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/recent_jobs_widget.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../profile/presentation/provider/profile_provider.dart';

class CompanyHomeTab extends StatefulWidget {
  final String companyId; // Accept companyId as a parameter

  const CompanyHomeTab({Key? key, required this.companyId}) : super(key: key);
  @override
  _CompanyHomeTabState createState() => _CompanyHomeTabState();
}

class _CompanyHomeTabState extends State<CompanyHomeTab> {
  bool isExpanded = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _hasInitialized) return;
      _hasInitialized = true;

      final feedProvider = context.read<FeedProvider>();

      // Reset user posts
      feedProvider.resetUserPosts();

      // Wait for userId to resolve before fetching posts
      final userId = await TokenService.getUserId();
      print('User ID: $userId');
      if (userId != null &&
          feedProvider.userPosts.isEmpty &&
          !feedProvider.isLoading) {
        await feedProvider.fetchUserPosts(widget.companyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);
    final myId = profile.userId;
    print('Jobs length: ${provider.jobs.length}');
    String fullText =
        provider.company?.overview?.isNotEmpty ?? false
            ? provider.company!.overview!
            : "No Overview available.";

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "Overview",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            if (provider.isLoading)
              Center(child: CircularProgressIndicator())
            else
              Stack(
                children: [
                  Text(
                    fullText,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: isExpanded ? null : 4,
                    overflow:
                        isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                  ),
                  if (!isExpanded && fullText.length > 200)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          //TODO: Redirect to the post
                          setState(() {
                            isExpanded = true;
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            " See More",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            if (isExpanded)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  key: const ValueKey('company_see_less_button'),

                  onPressed: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                  child: Text(
                    "See Less",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),
            if (provider.company?.website?.isNotEmpty ?? false)
              ListTile(
                leading: Icon(Icons.link, color: Colors.grey[700]),
                title: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: GestureDetector(
                    child: Text(
                      provider.company!.website!,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () async {
                      final Uri url = Uri.parse(
                        provider.company!.website ?? "https://www.google.com",
                      );

                      await launchUrl(url);
                    },
                  ),
                ),
              ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  key: const ValueKey('company_see_all_details_button'),
                  onPressed: () {
                    DefaultTabController.of(
                      context,
                    ).animateTo(1); // Index 1 for "About" tab
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700], // Text color
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Show all details",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Page posts",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth * 0.8;

                      // ✅ Check if no posts
                      if (feedProvider.userPosts.isEmpty) {
                        return const SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              "No posts available",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }

                      // ✅ Otherwise, return ListView
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
                                child: FutureBuilder<String?>(
                                  future: TokenService.getCompanyId(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final currentUserId = snapshot.data ?? '';
                                    return CompanyPostCard(
                                      post: post,
                                      currentUserId: currentUserId,
                                    );
                                  },
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
            ),

            Center(
              child: SizedBox(
                width: double.infinity, // Take full width
                child: TextButton(
                  key: const ValueKey('company_see_all_posts_button'),
                  onPressed: () {
                    DefaultTabController.of(
                      context,
                    ).animateTo(2); // Index 2 for "Posts" tab
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Show all posts",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward, color: Colors.grey[700]),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent job openings",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 10),
                RecentJobsWidget(userId: widget.companyId),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
