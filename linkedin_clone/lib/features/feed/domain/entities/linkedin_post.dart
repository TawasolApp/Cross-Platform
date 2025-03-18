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

  // Business logic methods
  void addMedia(String mediaUrl) => mediaUrls.add(mediaUrl);

  void tagUser(String userId) {
    if (!taggedUsers.contains(userId)) taggedUsers.add(userId);
  }

  void toggleSave() => isSaved = !isSaved;

  void addComment(String userId, String text) {
    comments.add(
      Comment(id: DateTime.now().toString(), userId: userId, text: text),
    );
  }

  void replyToComment(String commentId, String userId, String text) {
    final comment = comments.firstWhere(
      (c) => c.id == commentId,
      orElse: () => throw Exception("Comment not found"),
    );
    comment.replies.add(
      Comment(id: DateTime.now().toString(), userId: userId, text: text),
    );
  }

  void deleteComment(String commentId) =>
      comments.removeWhere((c) => c.id == commentId);

  void likePost(String userId, String reaction) => likes[userId] = reaction;

  void toggleLike(String userId) {
    if (likes.containsKey(userId)) {
      likes.remove(userId);
    } else {
      likes[userId] = "like"; // Default reaction
    }
  }

  List<String> getAllLikes() =>
      likes.entries.map((entry) => "${entry.key}: ${entry.value}").toList();
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
