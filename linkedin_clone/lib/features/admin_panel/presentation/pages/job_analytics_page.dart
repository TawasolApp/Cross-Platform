import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';

class JobAnalyticsPage extends StatelessWidget {
  const JobAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final job = Provider.of<AdminProvider>(context).jobAnalytics;

    return Scaffold(
      appBar: AppBar(title: const Text("Job Analytics")),
      body:
          job == null
              ? const Center(child: Text("No job analytics available."))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatCard(
                      title: "Total Jobs",
                      value: job.totalJobs.toString(),
                      icon: Icons.work,
                      color: Colors.purple,
                    ),
                    _buildStatCard(
                      title: "Most Applied Company ID",
                      value: job.mostAppliedCompany.id,
                      icon: Icons.apartment,
                      color: Colors.teal,
                      subtitle:
                          "Applications: ${job.mostAppliedCompany.applicationCount}",
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Most Applied Job",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(
                            job.mostAppliedJob.companyLogo,
                          ),
                        ),
                        title: Text(job.mostAppliedJob.position),
                        subtitle: Text(
                          "${job.mostAppliedJob.companyName} • ${job.mostAppliedJob.location}",
                        ),
                        trailing: const Icon(
                          Icons.trending_up,
                          color: Colors.green,
                        ),
                      ),
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
