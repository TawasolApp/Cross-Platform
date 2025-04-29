import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import '../widgets/user_reporting_stats.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AdminProvider>(context, listen: false).fetchAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    print("userAnalytics = ${provider.userAnalytics}");
    print("postAnalytics = ${provider.postAnalytics}");
    print("jobAnalytics = ${provider.jobAnalytics}");

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Analytics Dashboard")),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Admin Analytics Dashboard",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Track engagement, posts, and job performance across the platform for the past 30 days.",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SummaryCard(
                          label: "Total Users",
                          count:
                              provider.userAnalytics?.totalUsers.toString() ??
                              '-',
                          color: Colors.blue,
                        ),
                        _SummaryCard(
                          label: "Total Posts",
                          count:
                              provider.postAnalytics?.totalPosts.toString() ??
                              '-',
                          color: Colors.green,
                        ),
                        _SummaryCard(
                          label: "Total Jobs",
                          count:
                              provider.jobAnalytics?.totalJobs.toString() ??
                              '-',
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Most Active Users",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...provider.userAnalytics?.mostActiveUsers.map(
                          (user) => ListTile(
                            leading: const CircleAvatar(),
                            title: Text(user.userId),
                            subtitle: Text("Score: ${user.activityScore}"),
                          ),
                        ) ??
                        [const Text("No data available")],
                    UserReportingStats(
                      userId: provider.userAnalytics!.mostReportedUser,
                      reportCount: provider.userAnalytics!.userReportedCount,
                    ),
                  ],
                ),
              ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 3 - 20;
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
