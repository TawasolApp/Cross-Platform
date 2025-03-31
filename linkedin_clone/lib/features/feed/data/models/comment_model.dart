import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required String id,
    required String postId,
    required String authorId,
    required String authorName,
    required String authorPicture,
    required String authorBio,
    required String content,
    required List<String> taggedUsers,
    required List<CommentModel> replies,
    required int reactCount,
    required DateTime timestamp,
  }) : super(
         id: id,
         postId: postId,
         authorId: authorId,
         authorName: authorName,
         authorPicture: authorPicture,
         authorBio: authorBio,
         content: content,
         taggedUsers: taggedUsers,
         replies: replies,
         reactCount: reactCount,
         timestamp: timestamp,
       );

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['postId'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorPicture: json['authorPicture'],
      authorBio: json['authorBio'],
      content: json['content'],
      taggedUsers: List<String>.from(json['taggedUsers']),
      replies:
          (json['replies'] as List)
              .map((x) => CommentModel.fromJson(x))
              .toList(),
      reactCount: json['reactCount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorPicture': authorPicture,
      'authorBio': authorBio,
      'content': content,
      'taggedUsers': taggedUsers,
      'replies': replies.map((x) => (x as CommentModel).toJson()).toList(),
      'reactCount': reactCount,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
