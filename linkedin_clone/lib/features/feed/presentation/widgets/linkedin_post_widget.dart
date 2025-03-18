import 'package:flutter/material.dart';
import '../../../../core/themes/color_scheme.dart';
import '../../../../core/themes/text_styles.dart';
import '../../domain/entities/linkedin_post.dart';

class LinkedInPostWidget extends StatelessWidget {
  final LinkedInPost post;
  final Function(String userId, String reaction) onLike;
  final Function(String userId) onToggleSave;
  final Function(String userId, String text) onComment;

  LinkedInPostWidget({
    required this.post,
    required this.onLike,
    required this.onToggleSave,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Posted by: ${post.id}",
                  style: linkedinTextTheme.titleSmall,
                ),
                IconButton(
                  icon: Icon(
                    post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: linkedinLightColorScheme.primary,
                  ),
                  onPressed: () => onToggleSave(post.id),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Post Content
            Text(post.content, style: linkedinTextTheme.bodyMedium),
            const SizedBox(height: 8.0),

            // Media (if any)
            if (post.mediaUrls.isNotEmpty)
              SizedBox(
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.mediaUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        post.mediaUrls[index],
                        fit: BoxFit.cover,
                        width: 200.0,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8.0),

            // Likes and Comments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: linkedinLightColorScheme.primary,
                      ),
                      onPressed: () => onLike(post.id, "like"),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.celebration,
                        color: linkedinLightColorScheme.secondary,
                      ),
                      onPressed: () => onLike(post.id, "celebrate"),
                    ),
                    Text(
                      "${post.likes.length} Likes",
                      style: linkedinTextTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  "${post.comments.length} Comments",
                  style: linkedinTextTheme.bodySmall,
                ),
              ],
            ),
            const Divider(),

            // Comments Section
            Column(
              children:
                  post.comments.map((comment) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            child: Text(comment.userId[0].toUpperCase()),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.userId,
                                  style: linkedinTextTheme.titleSmall,
                                ),
                                Text(
                                  comment.text,
                                  style: linkedinTextTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 8.0),

            // Add Comment
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onSubmitted: (text) => onComment(post.id, text),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: linkedinLightColorScheme.primary,
                  ),
                  onPressed: () {
                    // Handle comment submission
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
