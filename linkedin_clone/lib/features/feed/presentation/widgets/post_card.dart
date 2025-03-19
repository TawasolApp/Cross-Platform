import 'package:flutter/material.dart';
import '/../../core/themes/color_scheme.dart';
import '/../../core/themes/text_styles.dart';
import 'like_button.dart';
import 'reaction_bar.dart';
import 'comment_section.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String content;
  final List<String> mediaUrls;
  final List<Comment> comments;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onCelebrate;
  final VoidCallback onToggleSave;

  PostCard({
    required this.postId,
    required this.content,
    this.mediaUrls = const [],
    this.comments = const [],
    required this.likeCount,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onCelebrate,
    required this.onToggleSave,
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
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://example.com/profile.jpg',
                      ),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mohab Zaghloul",
                          style: linkedinTextTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Computer Engineer",
                          style: linkedinTextTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: linkedinLightColorScheme.primary,
                  ),
                  onPressed: onToggleSave,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Post Content
            Text(
              content,
              style: linkedinTextTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 10),

            // Media (if any)
            if (mediaUrls.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mediaUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(
                          mediaUrls[index],
                          fit: BoxFit.cover,
                          width: 200.0,
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 10),

            // Reaction Bar
            ReactionBar(
              onLike: onLike,
              onComment: () {
                // Handle comment button press
              },
              onRepost: () {
                // Handle repost button press
              },
              onSend: () {
                // Handle send button press
              },
            ),
            const Divider(),

            // Comments Section
            CommentSection(
              comments: comments,
              onComment: (text) {
                // Handle adding a comment
                print("New comment: $text");
              },
            ),
          ],
        ),
      ),
    );
  }
}
