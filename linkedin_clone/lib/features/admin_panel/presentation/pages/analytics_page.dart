import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import 'user_analytics_page.dart';
import 'post_analytics_page.dart';
import 'job_analytics_page.dart';
import '../../../profile/presentation/provider/profile_provider.dart';

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
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      Provider.of<AdminProvider>(context, listen: false).fetchAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final user = provider.userAnalytics;
    final post = provider.postAnalytics;
    final job = provider.jobAnalytics;

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Analytics Dashboard")),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!))
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SummaryCard(
                          label: "Users",
                          count: user?.totalUsers.toString() ?? '-',
                          color: Colors.blue,
                        ),
                        _SummaryCard(
                          label: "Posts",
                          count: post?.totalPosts.toString() ?? '-',
                          color: Colors.green,
                        ),
                        _SummaryCard(
                          label: "Jobs",
                          count: job?.totalJobs.toString() ?? '-',
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person),
                      label: const Text("User Analytics"),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserAnalyticsPage(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.post_add),
                      label: const Text("Post Analytics"),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PostAnalyticsPage(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.work),
                      label: const Text("Job Analytics"),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const JobAnalyticsPage(),
                            ),
                          ),
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
    final width = MediaQuery.of(context).size.width / 3 - 24;
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
