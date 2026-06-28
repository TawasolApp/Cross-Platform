import '../../domain/entities/post_analytics_entity.dart';

class PostAnalyticsModel extends PostAnalytics {
  PostAnalyticsModel({
    required int totalPosts,
    required int totalShares,
    required int totalComments,
    required int totalReacts,
    required String postWithMostInteractions,
    required int postReportedCount,
    required String mostReportedPost,
  }) : super(
         totalPosts: totalPosts,
         totalShares: totalShares,
         totalComments: totalComments,
         totalReacts: totalReacts,
         postWithMostInteractions: postWithMostInteractions,
         postReportedCount: postReportedCount,
         mostReportedPost: mostReportedPost,
       );

  factory PostAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return PostAnalyticsModel(
      totalPosts: json['totalPosts'] ?? 0,
      totalShares: json['totalShares'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      totalReacts: json['totalReacts'] ?? 0,
      postWithMostInteractions: json['postWithMostInteractions'] ?? '',
      postReportedCount: json['postReportedCount'] ?? 0,
      mostReportedPost: json['mostReportedPost'] ?? '',
    );
  }
}
