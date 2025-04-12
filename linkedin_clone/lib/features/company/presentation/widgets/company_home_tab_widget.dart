import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_posts_tab.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/recent_jobs_widget.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/post_card.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyHomeTab extends StatefulWidget {
  final String companyId; // Accept companyId as a parameter

  const CompanyHomeTab({Key? key, required this.companyId}) : super(key: key);
  @override
  _CompanyHomeTabState createState() => _CompanyHomeTabState();
}

class _CompanyHomeTabState extends State<CompanyHomeTab> {
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      if (feedProvider.posts.isEmpty && !feedProvider.isLoading) {
        feedProvider.fetchUserPosts(widget.companyId); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context);

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
              child: Text(
                "Page posts",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SizedBox(
              height: 300,
              child:
                  feedProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : feedProvider.posts.isEmpty
                      ? Center(child: Text("No posts available"))
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            feedProvider.posts.length < 4
                                ? feedProvider.posts.length
                                : 4,
                        itemBuilder: (context, index) {
                          final post = feedProvider.posts[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Container(
                              width: 200, // Add a width constraint
                              child: PostCard(post: post), // Render PostCard
                            ),
                          );
                        },
                      ),
            ),

            Center(
              child: SizedBox(
                width: double.infinity, // Take full width
                child: TextButton(
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
