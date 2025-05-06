import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import 'user_analytics_page.dart';
import 'post_analytics_page.dart';
import 'job_analytics_page.dart';

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
    final user = provider.userAnalytics;
    final post = provider.postAnalytics;
    final job = provider.jobAnalytics;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View Analytics",
          key: ValueKey('analytics_appbar_title'),
        ),
      ),
      body:
          provider.isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  key: ValueKey('analytics_loader'),
                ),
              )
              : provider.errorMessage != null
              ? Center(
                child: Text(
                  provider.errorMessage!,
                  key: ValueKey('analytics_error'),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Summary",
                      key: ValueKey('analytics_summary_title'),
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
                          key: const ValueKey('analytics_summary_users'),
                          label: "Users",
                          count: user?.totalUsers.toString() ?? '-',
                          color: Colors.blue,
                        ),
                        _SummaryCard(
                          key: const ValueKey('analytics_summary_posts'),
                          label: "Posts",
                          count: post?.totalPosts.toString() ?? '-',
                          color: Colors.green,
                        ),
                        _SummaryCard(
                          key: const ValueKey('analytics_summary_jobs'),
                          label: "Jobs",
                          count: job?.totalJobs.toString() ?? '-',
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 20),
                    _buildDashboardTile(
                      key: const ValueKey('analytics_tile_user'),
                      icon: Icons.person,
                      label: "User Analytics",
                      color: Colors.blue,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserAnalyticsPage(),
                            ),
                          ),
                    ),
                    _buildDashboardTile(
                      key: const ValueKey('analytics_tile_post'),
                      icon: Icons.post_add,
                      label: "Post Analytics",
                      color: Colors.green,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PostAnalyticsPage(),
                            ),
                          ),
                    ),
                    _buildDashboardTile(
                      key: const ValueKey('analytics_tile_job'),
                      icon: Icons.work,
                      label: "Job Analytics",
                      color: Colors.purple,
                      onTap:
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

  Widget _buildDashboardTile({
    required Key key,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.indigo,
  }) {
    return Card(
      key: key,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, key: ValueKey('${key}_icon')),
        ),
        title: Text(
          label,
          key: ValueKey('${key}_label'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _SummaryCard({
    super.key,
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
            key: ValueKey('${key}_count'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            key: ValueKey('${key}_label'),
            style: const TextStyle(fontSize: 13, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
