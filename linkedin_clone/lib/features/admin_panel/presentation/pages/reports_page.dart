// import 'package:flutter/material.dart';
// import 'reported_users_page.dart';
// import 'reported_posts_page.dart';

// class ReportsPage extends StatelessWidget {
//   const ReportsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Report Management")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GridView(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 16,
//             crossAxisSpacing: 16,
//           ),
//           children: [
//             _ReportTile(
//               title: 'Reported Users',
//               icon: Icons.person_outline,
//               color: Colors.pink,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ReportedUsersPage()),
//                 );
//               },
//             ),
//             _ReportTile(
//               title: 'Reported Posts',
//               icon: Icons.article_outlined,
//               color: Colors.deepPurple,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ReportedPostsPage()),
//                 );
//               },
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ReportTile extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   const _ReportTile({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: color.withOpacity(0.1),
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 48, color: color),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'reported_users_page.dart';
import 'reported_posts_page.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Management",
          key: ValueKey("appbar_title_reports"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          children: [
            _ReportTile(
              key: const ValueKey("report_tile_users"),
              title: 'Reported Users',
              icon: Icons.person_outline,
              color: Colors.pink,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportedUsersPage()),
                );
              },
            ),
            _ReportTile(
              key: const ValueKey("report_tile_posts"),
              title: 'Reported Posts',
              icon: Icons.article_outlined,
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportedPostsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportTile({
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
        key: ValueKey("inkwell_${title.toLowerCase().replaceAll(" ", "_")}"),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color, key: ValueKey("icon_$title")),
            const SizedBox(height: 10),
            Text(
              title,
              key: ValueKey("text_$title"),
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
