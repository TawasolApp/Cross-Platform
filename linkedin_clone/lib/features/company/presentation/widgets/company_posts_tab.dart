import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/create_post_page.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/post_card.dart';
import 'package:provider/provider.dart';

class PostsTabWidget extends StatefulWidget {
  final String companyId;

  const PostsTabWidget({super.key, required this.companyId});

  @override
  _PostsTabWidgetState createState() => _PostsTabWidgetState();
}

class _PostsTabWidgetState extends State<PostsTabWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      await feedProvider.fetchUserPosts(widget.companyId); // Fetch posts
      print('Fetched posts for company: ${feedProvider.userPosts.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);

    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
        // Fetch isManager from CompanyProvider
        final bool isAdminView =
            companyProvider.isManager && !companyProvider.isViewingAsUser;
        print(isAdminView);

        return Scaffold(
          backgroundColor: Colors.white,
          body:
              feedProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount:
                        feedProvider.userPosts.length + (isAdminView ? 2 : 1),
                    itemBuilder: (context, index) {
                      if (isAdminView) {
                        if (index == 0) {
                          // Create Post Card
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 10.0,
                            ),
                            child: InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const PostCreationPage(),
                                  ),
                                );
                                if (result == true) {
                                  final feedProvider =
                                      Provider.of<FeedProvider>(
                                        context,
                                        listen: false,
                                      );
                                  await feedProvider.fetchUserPosts(
                                    widget.companyId,
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit, color: Colors.grey),
                                    SizedBox(width: 10),
                                    Text(
                                      "Create a Post...",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (index == 1) {
                          // Text "Posts"
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              "Company Posts",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        } else {
                          // Posts
                          final adjustedIndex = index - 2;
                          final post = feedProvider.userPosts[adjustedIndex];
                          //return PostCard(post: post);
                        }
                      } else {
                        if (index == 0) {
                          // Text "Company Posts" (non-admin view)
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              "Company Posts",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        } else {
                          final adjustedIndex = index - 1;
                          final post = feedProvider.userPosts[adjustedIndex];
                          //return PostCard(post: post);
                        }
                      }
                    },
                  ),
        );
      },
    );
  }
}
