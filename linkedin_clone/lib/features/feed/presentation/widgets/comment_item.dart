import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/comment_actions_footer.dart';
import '../../domain/entities/comment_entity.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  final String currentUserId;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.currentUserId,
    this.isReply = false,
  });

  String formatTimeAgo(DateTime timestamp) {
    final duration = DateTime.now().difference(timestamp);
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h';
    } else if (duration.inDays < 30) {
      return '${(duration.inDays / 30).floor()}d';
    } else if (duration.inDays < 365) {
      return '${(duration.inDays / 30).floor()}mon';
    } else {
      return '${(duration.inDays / 365).floor()}y';
    }
  }

  @override
  Widget build(BuildContext context) {
    print("comitem : userid:${currentUserId} authorid:${comment.authorId}");
    return Padding(
      padding: EdgeInsets.fromLTRB(isReply ? 32.0 : 8.0, 4.0, 8.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.authorPicture),
            radius: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(isReply ? 32.0 : 8.0, 4.0, 8.0, 4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 212, 212),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row (name, time)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        formatTimeAgo(comment.timestamp),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),

                  // Bio
                  Text(
                    comment.authorBio,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),

                  const SizedBox(height: 2),

                  // Comment content
                  Text(
                    comment.content,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ✅ Comment Footer Actions (Like | Reply | Edit | Delete)
                  CommentActionsFooter(
                    commentId: comment.id,
                    postId: comment.postId,
                    authorId: comment.authorId,
                    currentUserId: currentUserId,
                    commentContent: comment.content,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
