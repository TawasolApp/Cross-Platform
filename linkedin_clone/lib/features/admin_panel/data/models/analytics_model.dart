import '../../domain/entities/analytics_entity.dart';

class AnalyticsModel {
  static UserAnalytics userFromJson(Map<String, dynamic> json) {
    return UserAnalytics(
      totalUsers: json['total_users'],
      dailyActive: json['active_users']['daily'],
      weeklyActive: json['active_users']['weekly'],
      monthlyActive: json['active_users']['monthly'],
    );
  }

  static PostAnalytics postFromJson(Map<String, dynamic> json) {
    return PostAnalytics(
      totalPosts: json['total_posts'],
      mostActiveUsers: List<String>.from(json['most_active_users']),
      mostReportedPosts: List<String>.from(json['most_reported_posts']),
    );
  }

  static JobAnalytics jobFromJson(Map<String, dynamic> json) {
    return JobAnalytics(
      totalJobs: json['total_jobs'],
      mostAppliedCompanies: List<String>.from(json['most_applied_companies']),
    );
  }
}
