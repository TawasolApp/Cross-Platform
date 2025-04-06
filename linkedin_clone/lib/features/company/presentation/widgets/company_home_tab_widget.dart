import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/recent_jobs_widget.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyHomeTab extends StatefulWidget {
  final String userId; // Accept userId as a parameter

  const CompanyHomeTab({super.key, required this.userId});
  @override
  _CompanyHomeTabState createState() => _CompanyHomeTabState();
}

class _CompanyHomeTabState extends State<CompanyHomeTab> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);
    print("Posts length: ${provider.posts.length}");
    print('Jobs length: ${provider.jobs.length}');
    String fullText =
        provider.company?.description ?? "No description available.";

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
            if (provider.company?.website != null)
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
                  provider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : provider.posts.isEmpty
                      ? Center(child: Text("No posts available"))
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            provider.posts.length < 4
                                ? provider.posts.length
                                : 4,
                        itemBuilder: (context, index) {
                          final post = provider.posts[index];
                          print("Posts length: ${provider.posts.length}");

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print("Clicked on post by ${post.username}");
                              },
                              child: Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          post.profileImage,
                                        ),
                                      ),
                                      title: Text(
                                        post.username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${post.followers} followers",
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        post.text,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (post.imageUrl != null)
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            post.imageUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 120,
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.favorite_border,
                                                size: 18,
                                              ),
                                              SizedBox(width: 4),
                                              Text("${post.likes}"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.comment, size: 18),
                                              SizedBox(width: 4),
                                              Text("${post.comments}"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.share, size: 18),
                                              SizedBox(width: 4),
                                              Text("${post.shares}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                    // TODO: Navigate to  posts tab
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
                RecentJobsWidget(userId: widget.userId),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
