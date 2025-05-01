// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/feed_provider.dart';
// import 'comment_item.dart';

// class CommentList extends StatelessWidget {
//   final String postId;
//   final String currentUserId;
//   const CommentList({
//     super.key,
//     required this.postId,
//     required this.currentUserId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FeedProvider>(
//       builder: (context, feedProvider, child) {
//         final comments =
//             feedProvider.comments
//                 .where((comment) => comment.postId == postId)
//                 .toList();
//         if (feedProvider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (feedProvider.errorMessage != null) {
//           return Center(
//             child: Text(
//               feedProvider.errorMessage!,
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         }
//         if (comments.isEmpty) {
//           return const Center(
//             child: Text(
//               'No comments yet',
//               style: TextStyle(color: Colors.grey),
//             ),
//           );
//         }

//         return Container(
//           color: Colors.white, // Set the background color to white
//           child: ListView.builder(
//             padding: const EdgeInsets.all(8.0),
//             itemCount: feedProvider.comments.length,
//             itemBuilder: (context, index) {
//               final comment = feedProvider.comments[index];
//               return CommentItem(
//                 comment: comment,
//                 currentUserId: currentUserId,
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import 'comment_item.dart';
import '../../data/models/comment_model.dart';

class CommentList extends StatelessWidget {
  final String postId;
  final String currentUserId;

  const CommentList({
    super.key,
    required this.postId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        final allComments = feedProvider.comments;
        final topLevel =
            allComments.where((c) => c.postId == postId && !c.isReply).toList();
        final replies = allComments.where((c) => c.isReply).toList();

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200 &&
                feedProvider.hasMoreComments &&
                !feedProvider.isLoading) {
              feedProvider.fetchComments(postId);
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () => feedProvider.fetchComments(postId, refresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 100),
              itemCount:
                  topLevel.length + (feedProvider.hasMoreComments ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == topLevel.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final parent = topLevel[index];
                if (parent.repliesCount > 0 &&
                    !replies.any((r) => r.postId == parent.id)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    feedProvider.fetchComments(parent.id);
                  });
                }

                final childReplies =
                    replies.where((r) => r.postId == parent.id).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommentItem(
                      comment: parent,
                      currentUserId: currentUserId,
                      isReply: false,
                    ),
                    ...childReplies.map(
                      (r) => CommentItem(
                        comment: r,
                        currentUserId: currentUserId,
                        isReply: true,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
