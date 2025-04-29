class MostActiveUser {
  final String userId;
  final int activityScore;

  MostActiveUser({required this.userId, required this.activityScore});
}

class UserAnalytics {
  final int totalUsers;
  final List<MostActiveUser> mostActiveUsers;
  final String mostReportedUser;
  final int userReportedCount;

  UserAnalytics({
    required this.totalUsers,
    required this.mostActiveUsers,
    required this.mostReportedUser,
    required this.userReportedCount,
  });
}
