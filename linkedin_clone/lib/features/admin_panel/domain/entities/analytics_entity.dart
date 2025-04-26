class UserAnalytics {
  final int totalUsers;
  final int dailyActive;
  final int weeklyActive;
  final int monthlyActive;

  UserAnalytics({
    required this.totalUsers,
    required this.dailyActive,
    required this.weeklyActive,
    required this.monthlyActive,
  });
}

class PostAnalytics {
  final int totalPosts;
  final List<String> mostActiveUsers;
  final List<String> mostReportedPosts;

  PostAnalytics({
    required this.totalPosts,
    required this.mostActiveUsers,
    required this.mostReportedPosts,
  });
}

class JobAnalytics {
  final int totalJobs;
  final List<String> mostAppliedCompanies;

  JobAnalytics({required this.totalJobs, required this.mostAppliedCompanies});
}
