import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../../../../core/services/token_service.dart';
import '../pages/create_post_page.dart';

Future<String> get userId async {
  final isCompany = await TokenService.getIsCompany();
  return isCompany == false
      ? await TokenService.getCompanyId() ?? ''
      : await TokenService.getUserId() ?? '';
}

void showRepostBottomSheet(
  BuildContext context,
  String postId,
  String? profileImage,
  String profileName,
  String? profileTitle,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    builder:
        (_) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text("Repost with your thoughts"),
                subtitle: const Text(
                  "Create a new post with this post attached",
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final resolvedUserId = await userId;
                  // context.push(
                  //   RouteNames.createPost,
                  //   extra: {
                  //     "userId": resolvedUserId,
                  //     "parentPostId": postId,
                  //     "isSilentRepost": false,
                  //   },
                  // );
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PostCreationPage(
                            authorImage: profileImage,
                            authorName: profileName,
                            authorTitle: profileTitle,
                            parentPostId: postId,
                            isSilentRepost: false,
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.repeat_outlined),
                title: const Text("Repost"),
                subtitle: const Text(
                  "Instantly bring this post to others' feeds",
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final feedProvider = Provider.of<FeedProvider>(
                    context,
                    listen: false,
                  );
                  await feedProvider.createPost(
                    content: "Reposted",
                    media: [],
                    visibility: feedProvider.visibility,
                    parentPostId: postId,
                    isSilentRepost: true,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post reposted successfully!'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
  );
}
