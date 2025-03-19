import 'package:flutter/material.dart';
import '../../core/themes/color_scheme.dart';
import '../../core/themes/text_styles.dart';

class LinkedInPost {
  String id;
  String content;
  List<String> mediaUrls;
  List<String> taggedUsers;
  List<Comment> comments;
  Map<String, String> likes; // userId -> reaction type
  bool isSaved;

  LinkedInPost({
    required this.id,
    required this.content,
    this.mediaUrls = const [],
    this.taggedUsers = const [],
    this.comments = const [],
    this.likes = const {},
    this.isSaved = false,
  });

  // Add media to the post
  void addMedia(String mediaUrl) {
    mediaUrls.add(mediaUrl);
  }

  // Tag a user in the post
  void tagUser(String userId) {
    if (!taggedUsers.contains(userId)) {
      taggedUsers.add(userId);
    }
  }

  // Save or unsave the post
  void toggleSave() {
    isSaved = !isSaved;
  }

  // Add a comment to the post
  void addComment(String userId, String text) {
    comments.add(
      Comment(id: DateTime.now().toString(), userId: userId, text: text),
    );
  }

  // Reply to a comment
  void replyToComment(String commentId, String userId, String text) {
    final comment = comments.firstWhere(
      (c) => c.id == commentId,
      orElse: () => throw Exception("Comment not found"),
    );
    comment.replies.add(
      Comment(id: DateTime.now().toString(), userId: userId, text: text),
    );
  }

  // Delete a comment
  void deleteComment(String commentId) {
    comments.removeWhere((c) => c.id == commentId);
  }

  // Like the post with a specific reaction
  void likePost(String userId, String reaction) {
    likes[userId] = reaction;
  }

  // Remove like by clicking again
  void toggleLike(String userId) {
    if (likes.containsKey(userId)) {
      likes.remove(userId);
    } else {
      likes[userId] = "like"; // Default reaction
    }
  }

  // Get a list of all likes
  List<String> getAllLikes() {
    return likes.entries
        .map((entry) => "${entry.key}: ${entry.value}")
        .toList();
  }
}

class Comment {
  String id;
  String userId;
  String text;
  List<Comment> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.text,
    this.replies = const [],
  });
}

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
      color: Theme.of(context).cardColor, // Use theme's card color
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
                  "Posted by: ${post.id}", // Replace with user name if available
                  style: linkedinTextTheme.titleSmall, // Updated text style
                ),
                IconButton(
                  icon: Icon(
                    post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: linkedinLightColorScheme.primary, // Updated color
                  ),
                  onPressed: () => onToggleSave(post.id),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Post Content
            Text(
              post.content,
              style: linkedinTextTheme.bodyMedium, // Updated text style
            ),
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
                      style: linkedinTextTheme.bodySmall, // Updated text style
                    ),
                  ],
                ),
                Text(
                  "${post.comments.length} Comments",
                  style: linkedinTextTheme.bodySmall, // Updated text style
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
                            child: Text(
                              comment.userId[0].toUpperCase(),
                            ), // Placeholder avatar
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.userId,
                                  style:
                                      linkedinTextTheme
                                          .titleSmall, // Updated text style
                                ),
                                Text(
                                  comment.text,
                                  style:
                                      linkedinTextTheme
                                          .bodySmall, // Updated text style
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
