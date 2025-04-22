import 'package:flutter/material.dart';
import 'delete_post_dialog.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../pages/create_post_page.dart';

class PostActionsBottomSheet extends StatelessWidget {
  final String postId;
  final String postContent;
  final String authorImage;
  final String authorName;
  final String authorTitle;
  final String visibility;
  final BuildContext rootContext;
  final String authorId;
  final String currentUserId;

  const PostActionsBottomSheet({
    super.key,
    required this.postId,
    required this.postContent,
    required this.authorImage,
    required this.authorName,
    required this.authorTitle,
    required this.visibility,
    required this.rootContext,
    required this.authorId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final isSaved =
        feedProvider.posts.firstWhere((p) => p.id == postId).isSaved;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(height: 4, width: 40, color: Colors.grey[300]),
          const SizedBox(height: 16),

          ListTile(
            leading: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? Colors.grey : null,
            ),
            title: Text(isSaved ? "Unsave" : "Save"),
            onTap: () async {
              Navigator.pop(context); // Close bottom sheet

              // Perform save or unsave based on current state
              if (isSaved) {
                await feedProvider.unsavePost(currentUserId, postId);
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  const SnackBar(
                    content: Text("Post unsaved successfully"),
                    backgroundColor: Colors.orange,
                  ),
                );
              } else {
                await feedProvider.savePost(currentUserId, postId);
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  const SnackBar(
                    content: Text("Post saved successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),

          if (authorId == currentUserId) ...[
            // Edit Post
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the edit screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PostCreationPage(
                          postId: postId,
                          initialContent: postContent,
                          visibility: visibility,
                          authorImage: authorImage,
                          authorName: authorName,
                          authorTitle: authorTitle,
                          userId: currentUserId,
                        ),
                  ),
                );
              },
            ),
          ],

          // Report Post
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report'),
            onTap: () {
              Navigator.pop(context);
              // Handle report action here (Privacy and Security module)
              ScaffoldMessenger.of(rootContext).showSnackBar(
                const SnackBar(
                  content: Text("Post reported successfully"),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),

          if (authorId == currentUserId) ...[
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text("Delete post"),
              onTap: () {
                Navigator.pop(context);
                showDeletePostDialog(
                  context: context,
                  onDelete: () async {
                    await feedProvider.deletePost(currentUserId, postId);
                    final message = feedProvider.errorMessage;
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      SnackBar(
                        content: Text(message ?? 'Post deleted successfully'),
                        backgroundColor:
                            message == null ? Colors.green : Colors.red,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
