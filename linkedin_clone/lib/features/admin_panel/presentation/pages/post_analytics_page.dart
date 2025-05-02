import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';

class PostAnalyticsPage extends StatelessWidget {
  const PostAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<AdminProvider>(context).postAnalytics;

    return Scaffold(
      appBar: AppBar(title: const Text("Post Analytics")),
      body:
          post == null
              ? const Center(child: Text("No post analytics available."))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatCard(
                      title: "Total Posts",
                      value: post.totalPosts.toString(),
                      icon: Icons.post_add,
                      color: Colors.green,
                    ),
                    _buildStatCard(
                      title: "Total Comments",
                      value: post.totalComments.toString(),
                      icon: Icons.comment,
                      color: Colors.blueGrey,
                    ),
                    _buildStatCard(
                      title: "Total Reactions",
                      value: post.totalReacts.toString(),
                      icon: Icons.thumb_up_alt,
                      color: Colors.deepOrange,
                    ),
                    _buildStatCard(
                      title: "Total Shares",
                      value: post.totalShares.toString(),
                      icon: Icons.share,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 20),
                    _buildStatCard(
                      title: "Post With Most Interactions",
                      value: post.postWithMostInteractions,
                      icon: Icons.trending_up,
                      color: Colors.teal,
                    ),
                    _buildStatCard(
                      title: "Most Reported Post",
                      value: post.mostReportedPost,
                      icon: Icons.report,
                      color: Colors.redAccent,
                      subtitle: "Reported ${post.postReportedCount} times",
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    String? subtitle,
    Color color = Colors.blue,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(title, style: const TextStyle(fontSize: 14)),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
