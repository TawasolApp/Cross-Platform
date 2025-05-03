import 'package:flutter/material.dart';
import 'analytics_page.dart';
import 'job_listings_page.dart';
import 'reports_page.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Admin Panel',
          key: ValueKey('admin_appbar_title'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView(
          key: const ValueKey('admin_gridview'),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          children: [
            _AdminPanelTile(
              key: const ValueKey('admin_tile_analytics'),
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
              key: const ValueKey('admin_tile_jobs'),
              title: 'Job Listings',
              icon: Icons.work_outline,
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminJobListingsPage(),
                  ),
                );
              },
            ),
            _AdminPanelTile(
              key: const ValueKey('admin_tile_reports'),
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
            Icon(
              icon,
              size: 48,
              color: color,
              key: ValueKey('admin_icon_$title'),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              key: ValueKey('admin_text_$title'),
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
