import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Users: ${provider.userAnalytics?.totalUsers ?? '-'}",
                      key: const ValueKey('analyticsTotalUsers'),
                    ),
                    Text(
                      "Daily Active: ${provider.userAnalytics?.dailyActive ?? '-'}",
                      key: const ValueKey('analyticsDailyActive'),
                    ),
                    Text(
                      "Weekly Active: ${provider.userAnalytics?.weeklyActive ?? '-'}",
                      key: const ValueKey('analyticsWeeklyActive'),
                    ),
                    Text(
                      "Monthly Active: ${provider.userAnalytics?.monthlyActive ?? '-'}",
                      key: const ValueKey('analyticsMonthlyActive'),
                    ),
                    const Divider(height: 30),
                    Text(
                      "Total Posts: ${provider.postAnalytics?.totalPosts ?? '-'}",
                      key: const ValueKey('analyticsTotalPosts'),
                    ),
                    Text(
                      "Most Active Users: ${provider.postAnalytics?.mostActiveUsers.join(', ') ?? '-'}",
                      key: const ValueKey('analyticsMostActiveUsers'),
                    ),
                    Text(
                      "Most Reported Posts: ${provider.postAnalytics?.mostReportedPosts.join(', ') ?? '-'}",
                      key: const ValueKey('analyticsMostReportedPosts'),
                    ),
                    const Divider(height: 30),
                    Text(
                      "Total Jobs: ${provider.jobAnalytics?.totalJobs ?? '-'}",
                      key: const ValueKey('analyticsTotalJobs'),
                    ),
                    Text(
                      "Top Companies: ${provider.jobAnalytics?.mostAppliedCompanies.join(', ') ?? '-'}",
                      key: const ValueKey('analyticsTopCompanies'),
                    ),
                  ],
                ),
              ),
    );
  }
}
