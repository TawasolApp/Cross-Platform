import '../../domain/entities/sub_post_entities.dart';

class RepostDetailsModel extends RepostDetails {
  RepostDetailsModel({
    required super.authorId,
    required super.postId,
    required super.content,
    List<String>? taggedUsers,
    required super.visibility,
    required super.authorType,
  }) : super(
         taggedUsers: taggedUsers ?? [],
       );

  factory RepostDetailsModel.fromJson(Map<String, dynamic> json) {
    return RepostDetailsModel(
      authorId: json['authorId'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
      taggedUsers:
          (json['taggedUsers'] as List<dynamic>?)?.cast<String>() ?? [],
      visibility: json['visibility'] as String,
      authorType: json['authorType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'postId': postId,
      'content': content,
      'taggedUsers': taggedUsers,
      'visibility': visibility,
      'authorType': authorType,
    };
  }
}
