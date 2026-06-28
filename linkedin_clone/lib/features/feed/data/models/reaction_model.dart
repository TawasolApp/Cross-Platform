import '../../domain/entities/reaction_entity.dart';

class ReactionModel extends ReactionEntity {
  ReactionModel({
    required super.likeId,
    required super.postId,
    required super.authorId,
    required super.authorType,
    required super.type,
    required super.authorName,
    required super.authorPicture,
    required super.authorBio,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      likeId: json['likeId'],
      postId: json['postId'],
      authorId: json['authorId'],
      authorType: json['authorType'],
      type: json['type'],
      authorName: json['authorName'],
      authorPicture: json['authorPicture'],
      authorBio: json['authorBio'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'likeId': likeId,
      'postId': postId,
      'authorId': authorId,
      'authorType': authorType,
      'type': type,
      'authorName': authorName,
      'authorPicture': authorPicture,
      'authorBio': authorBio,
    };
  }
}
