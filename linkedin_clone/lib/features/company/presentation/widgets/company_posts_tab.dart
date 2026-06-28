import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/create_post_page.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/user_feed_page.dart';
import 'package:provider/provider.dart';

class PostsTabWidget extends StatefulWidget {
  final String companyId;

  const PostsTabWidget({super.key, required this.companyId});

  @override
  _PostsTabWidgetState createState() => _PostsTabWidgetState();
}

class _PostsTabWidgetState extends State<PostsTabWidget> {
  bool _hasReset = false;

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
    print("Company ID: ${widget.companyId}");

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
                  : Column(
                    children: [
                      if (isAdminView)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 10.0,
                          ),
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostCreationPage(),
                                ),
                              );
                              if (result == true) {
                                final feedProvider = Provider.of<FeedProvider>(
                                  context,
                                  listen: false,
                                );
                                await feedProvider.fetchUserPosts(
                                  widget.companyId,
                                  forceRefresh: true,
                                );
                                print(
                                  "Posts fetched after creating a new post.",
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
                        ),
                      const Padding(
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
                      ),

                      Expanded(
                        child:
                            feedProvider.userPosts.isEmpty
                                ? (companyProvider.isManager &&
                                        !companyProvider.isViewingAsUser
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.post_add_outlined,
                                            size: 80,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No Posts Yet',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Create your first post to engage with your audience.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : const Center(
                                      child: Text(
                                        "No posts available",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ))
                                : UserFeedPage(
                                  companyId: widget.companyId,
                                  userId: widget.companyId,
                                  showFAB:
                                      false, // Hide FAB because we already show a create post card
                                ),
                      ),
                    ],
                  ),
        );
      },
    );
  }
}
