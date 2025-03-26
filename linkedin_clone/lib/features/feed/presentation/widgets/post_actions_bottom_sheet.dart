// import 'package:flutter/material.dart';
// import 'delete_post_dialog.dart';
// import 'package:provider/provider.dart';
// import '../provider/feed_provider.dart';

// class PostActionsBottomSheet extends StatelessWidget {
//   final String postId;

//   const PostActionsBottomSheet({super.key, required this.postId});

//   @override
//   Widget build(BuildContext context) {
//     final isSaved =
//       Provider.of<FeedProvider>(
//         context,
//         listen: false,
//       ).posts.firstWhere((p) => p.id == postId).isSaved;
//     return SafeArea(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 10),
//           Container(height: 4, width: 40, color: Colors.grey[300]),
//           const SizedBox(height: 16),
//           ListTile(
//             leading: const Icon(Icons.bookmark_border),
//             title: const Text("Save"),
//             onTap: () {
//               Navigator.pop(context);
//               Provider.of<FeedProvider>(
//                 context,
//                 listen: false,
//               ).savePost(postId);
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(const SnackBar(content: Text("Post saved")));
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.bookmark, color: isSaved ? Colors.grey : null),
//             title: Text(isSaved ? "Unsave" : "Save"),
//             onTap: () {
//               Navigator.pop(context); // close bottom sheet

//               Provider.of<FeedProvider>(
//                 context,
//                 listen: false,
//               ).toggleSavePost(postId);

//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     isSaved
//                         ? "Post unsaved successfully"
//                         : "Post saved successfully",
//                   ),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.delete_outline),
//             title: const Text("Delete post"),
//             onTap: () {
//               Navigator.pop(context); // Close bottom sheet first
//               showDeletePostDialog(
//                 context: context,
//                 onDelete: () {
//                   Provider.of<FeedProvider>(
//                     context,
//                     listen: false,
//                   ).deletePost(postId);
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'delete_post_dialog.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';

class PostActionsBottomSheet extends StatelessWidget {
  final String postId;

  const PostActionsBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final isSaved =
        Provider.of<FeedProvider>(
          context,
        ).posts.firstWhere((p) => p.id == postId).isSaved;

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
            onTap: () {
              Navigator.pop(context); // Close bottom sheet

              Provider.of<FeedProvider>(
                context,
                listen: false,
              ).savePost(postId);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved
                        ? "Post unsaved successfully"
                        : "Post saved successfully",
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text("Delete post"),
            onTap: () {
              Navigator.pop(context); // Close bottom sheet
              showDeletePostDialog(
                context: context,
                onDelete: () {
                  Provider.of<FeedProvider>(
                    context,
                    listen: false,
                  ).deletePost(postId);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
