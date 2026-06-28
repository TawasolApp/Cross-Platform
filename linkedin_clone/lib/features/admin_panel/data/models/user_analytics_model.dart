import '../../domain/entities/user_analytics_entity.dart';

class MostActiveUserModel extends MostActiveUser {
  MostActiveUserModel({required String userId, required int activityScore})
    : super(userId: userId, activityScore: activityScore);

  factory MostActiveUserModel.fromJson(Map<String, dynamic> json) {
    return MostActiveUserModel(
      userId: json['userId'] ?? '',
      activityScore: json['activityScore'] ?? 0,
    );
  }
}

class UserAnalyticsModel extends UserAnalytics {
  UserAnalyticsModel({
    required int totalUsers,
    required List<MostActiveUser> mostActiveUsers,
    required String mostReportedUser,
    required int userReportedCount,
  }) : super(
         totalUsers: totalUsers,
         mostActiveUsers: mostActiveUsers,
         mostReportedUser: mostReportedUser,
         userReportedCount: userReportedCount,
       );

  factory UserAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return UserAnalyticsModel(
      totalUsers: json['totalUsers'] ?? 0,
      mostReportedUser: json['mostReportedUser'] ?? '',
      userReportedCount: json['userReportedCount'] ?? 0,
      mostActiveUsers:
          (json['mostActiveUsers'] as List<dynamic>? ?? [])
              .map((e) => MostActiveUserModel.fromJson(e))
              .toList(),
    );
  }
}
