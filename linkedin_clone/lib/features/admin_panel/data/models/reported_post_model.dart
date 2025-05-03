import '../../domain/entities/reported_post_entity.dart';

class ReportedPostModel extends ReportedPost {
  ReportedPostModel({
    required super.id,
    required super.status,
    required super.postContent,
    required super.postMedia,
    required super.postAuthor,
    required super.postAuthorRole,
    required super.postAuthorAvatar,
    required super.postAuthorType,
    required super.reportedBy,
    required super.reporterAvatar,
    required super.reason,
    required super.reportedAt,
  });

  factory ReportedPostModel.fromJson(Map<String, dynamic> json) {
    return ReportedPostModel(
      id: json['id'],
      status: json['status'],
      postContent: json['postContent'],
      postMedia: json['postMedia'],
      postAuthor: json['postAuthor'],
      postAuthorRole: json['postAuthorRole'],
      postAuthorAvatar: json['postAuthorAvatar'],
      postAuthorType: json['postAuthorType'],
      reportedBy: json['reportedBy'],
      reporterAvatar: json['reporterAvatar'],
      reason: json['reason'],
      reportedAt: DateTime.parse(json['reportedAt']),
    );
  }
}
