import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import '../widgets/reported_post_card.dart'; // adjust import path

class ReportedPostsPage extends StatefulWidget {
  const ReportedPostsPage({super.key});

  @override
  State<ReportedPostsPage> createState() => _ReportedPostsPageState();
}

class _ReportedPostsPageState extends State<ReportedPostsPage> {
  String _selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    Provider.of<AdminProvider>(
      context,
      listen: false,
    ).fetchReportedPosts(status: _selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final posts = provider.reportedPosts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reported Posts"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: _selectedStatus,
              underline: const SizedBox(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                  provider.fetchReportedPosts(status: value);
                }
              },
              items: const [
                DropdownMenuItem(value: 'Pending', child: Text("Pending")),
                DropdownMenuItem(value: 'Actioned', child: Text("Actioned")),
                DropdownMenuItem(value: 'Dismissed', child: Text("Dismissed")),
              ],
            ),
          ),
        ],
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ReportedPostCard(
                    post: post,
                    onIgnore: () {
                      provider.resolvePostReport(post.id, "ignore");
                    },
                    onDelete: () {
                      //provider.deleteReportedPost(post.companyId, post.id);
                    },
                    onSuspendUser: () {
                      provider.resolvePostReport(
                        post.id,
                        "suspend_user",
                        comment: "Harassment",
                      );
                    },
                  );
                },
              ),
    );
  }
}
