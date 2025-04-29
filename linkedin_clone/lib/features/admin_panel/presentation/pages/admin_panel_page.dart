import 'package:flutter/material.dart';
import 'analytics_page.dart';
import 'job_listings_page.dart';
import 'reports_page.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          children: [
            _AdminPanelTile(
              title: 'Analytics',
              icon: Icons.analytics,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsPage()),
                );
              },
            ),
            _AdminPanelTile(
              title: 'Job Listings',
              icon: Icons.work_outline,
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JobListingsPage()),
                );
              },
            ),
            _AdminPanelTile(
              title: 'Reports',
              icon: Icons.flag_outlined,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminPanelTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminPanelTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
