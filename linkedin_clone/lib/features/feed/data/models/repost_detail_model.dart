import '../../domain/entities/sub_post_entities.dart';

class RepostDetailsModel extends RepostDetails {
  const RepostDetailsModel({
    required String authorId,
    required String postId,
    required String content,
    List<String>? taggedUsers,
    required String visibility,
    required String authorType,
  }) : super(
         authorId: authorId,
         postId: postId,
         content: content,
         taggedUsers: taggedUsers,
         visibility: visibility,
         authorType: authorType,
       );

  //Convert JSON to Model
  factory RepostDetailsModel.fromJson(Map<String, dynamic> json) {
    return RepostDetailsModel(
      authorId: json['authorId'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
      taggedUsers:
          (json['taggedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      visibility: json['visibility'] as String,
      authorType: json['authorType'] as String,
    );
  }

  //Convert Model to JSON
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
