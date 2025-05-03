import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import '../widgets/reported_post_card.dart';

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
        title: const Text(
          "Reported Posts",
          key: ValueKey('reported_posts_appbar_title'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(iconTheme: const IconThemeData(color: Colors.white)),
              child: DropdownButton<String>(
                key: const ValueKey('reported_posts_dropdown'),
                dropdownColor: Colors.grey[800],
                iconEnabledColor: Colors.white,
                value: _selectedStatus,
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                    provider.fetchReportedPosts(status: value);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 'Pending',
                    child: Text(
                      "Pending",
                      key: ValueKey('reported_posts_option_pending'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Actioned',
                    child: Text(
                      "Actioned",
                      key: ValueKey('reported_posts_option_actioned'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Dismissed',
                    child: Text(
                      "Dismissed",
                      key: ValueKey('reported_posts_option_dismissed'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body:
          provider.isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  key: ValueKey('reported_posts_loading'),
                ),
              )
              : provider.errorMessage != null
              ? Center(
                child: Text(
                  provider.errorMessage!,
                  key: const ValueKey('reported_posts_error_message'),
                ),
              )
              : posts.isEmpty
              ? Center(
                child: Text(
                  "No ${_selectedStatus.toLowerCase()} posts",
                  key: ValueKey(
                    'reported_posts_empty_${_selectedStatus.toLowerCase()}',
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ReportedPostCard(
                    key: ValueKey('reported_posts_card_$index'),
                    post: post,
                    onIgnore: () {
                      provider.resolvePostReport(post.id, "ignore");
                    },
                    onDelete: () {
                      // provider.deleteReportedPost(post.companyId, post.id);
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

///
// ///import 'package\:flutter/material.dart';
// import 'package\:provider/provider.dart';
// import '../provider/admin\_provider.dart';
// import '../widgets/reported\_post\_card.dart'; // adjust import path

// class ReportedPostsPage extends StatefulWidget {
// const ReportedPostsPage({super.key});

// @override
// State<ReportedPostsPage> createState() => \_ReportedPostsPageState();
// }

// class _ReportedPostsPageState extends State<ReportedPostsPage> {
// String _selectedStatus = 'Pending';

// @override
// void initState() {
// super.initState();
// Provider.of<AdminProvider>(
// context,
// listen: false,
// ).fetchReportedPosts(status: \_selectedStatus);
// }

// @override
// Widget build(BuildContext context) {
// final provider = Provider.of<AdminProvider>(context);
// final posts = provider.reportedPosts;

// ```
// return Scaffold(
//   appBar: AppBar(
//     title: const Text("Reported Posts"),
//     actions: [
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Theme(
//           data: Theme.of(
//             context,
//           ).copyWith(iconTheme: const IconThemeData(color: Colors.white)),
//           child: DropdownButton<String>(
//             dropdownColor: Colors.grey[800],
//             iconEnabledColor: Colors.white,
//             value: _selectedStatus,
//             underline: const SizedBox(),
//             style: const TextStyle(color: Colors.white),
//             onChanged: (value) {
//               if (value != null) {
//                 setState(() => _selectedStatus = value);
//                 provider.fetchReportedPosts(status: value); // ✅ fixed here
//               }
//             },
//             items: const [
//               DropdownMenuItem(
//                 value: 'Pending',
//                 child: Text(
//                   "Pending",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'Actioned',
//                 child: Text(
//                   "Actioned",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'Dismissed',
//                 child: Text(
//                   "Dismissed",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ],
//   ),
//   body:
//       provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.errorMessage != null
//           ? Center(child: Text(provider.errorMessage!))
//           : posts.isEmpty
//           ? Center(
//             child: Text(
//               "No ${_selectedStatus.toLowerCase()} posts",
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           )
//           : ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: posts.length,
//             itemBuilder: (context, index) {
//               final post = posts[index];
//               return ReportedPostCard(
//                 post: post,
//                 onIgnore: () {
//                   provider.resolvePostReport(post.id, "ignore");
//                 },
//                 onDelete: () {
//                   //provider.deleteReportedPost(post.companyId, post.id);
//                 },
//                 onSuspendUser: () {
//                   provider.resolvePostReport(
//                     post.id,
//                     "suspend_user",
//                     comment: "Harassment",
//                   );
//                 },
//               );
//             },
//           ),
// );
// ```

// }
// }
