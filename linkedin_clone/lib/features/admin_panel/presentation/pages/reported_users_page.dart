// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/admin_provider.dart';
// import '../widgets/reported_user_card.dart';

// class ReportedUsersPage extends StatefulWidget {
//   const ReportedUsersPage({super.key});

//   @override
//   State<ReportedUsersPage> createState() => _ReportedUsersPageState();
// }

// class _ReportedUsersPageState extends State<ReportedUsersPage> {
//   String _selectedStatus = 'Pending';

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<AdminProvider>(
//       context,
//       listen: false,
//     ).fetchReportedUsers(status: _selectedStatus);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<AdminProvider>(context);
//     final users = provider.reportedUsers;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Reported Users"),

//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),

//             child: Theme(
//               data: Theme.of(context).copyWith(
//                 iconTheme: const IconThemeData(
//                   color: Colors.white,
//                 ), // dropdown arrow
//               ),
//               child: DropdownButton<String>(
//                 dropdownColor: Colors.grey[800],
//                 iconEnabledColor: Colors.white, // white dropdown background
//                 value: _selectedStatus,
//                 underline: const SizedBox(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                 ), // selected text in app bar
//                 onChanged: (value) {
//                   if (value != null) {
//                     setState(() => _selectedStatus = value);
//                     provider.fetchReportedUsers(status: value);
//                   }
//                 },
//                 items: const [
//                   DropdownMenuItem(
//                     value: 'Pending',
//                     child: Text(
//                       "Pending",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: 'Actioned',
//                     child: Text(
//                       "Actioned",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: 'Dismissed',
//                     child: Text(
//                       "Dismissed",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       body:
//           provider.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : provider.errorMessage != null
//               ? Center(child: Text(provider.errorMessage!))
//               : ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final reportedUser = users[index];

//                   return ReportedUserCard(
//                     user: reportedUser,
//                     onIgnore: () {
//                       provider.resolveUserReport(reportedUser.id, "Dismissed");
//                     },
//                     onSuspend: () {
//                       provider.resolveUserReport(reportedUser.id, "Suspend");
//                     },
//                   );
//                 },
//               ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import '../widgets/reported_user_card.dart';

class ReportedUsersPage extends StatefulWidget {
  const ReportedUsersPage({super.key});

  @override
  State<ReportedUsersPage> createState() => _ReportedUsersPageState();
}

class _ReportedUsersPageState extends State<ReportedUsersPage> {
  String _selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    Provider.of<AdminProvider>(
      context,
      listen: false,
    ).fetchReportedUsers(status: _selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final users = provider.reportedUsers;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reported Users",
          key: ValueKey('reported_users_title'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(iconTheme: const IconThemeData(color: Colors.white)),
              child: DropdownButton<String>(
                key: const ValueKey('reported_users_dropdown'),
                dropdownColor: Colors.grey[800],
                iconEnabledColor: Colors.white,
                value: _selectedStatus,
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                    provider.fetchReportedUsers(status: value);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 'Pending',
                    child: Text(
                      "Pending",
                      key: ValueKey('reported_users_option_pending'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Actioned',
                    child: Text(
                      "Actioned",
                      key: ValueKey('reported_users_option_actioned'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Dismissed',
                    child: Text(
                      "Dismissed",
                      key: ValueKey('reported_users_option_dismissed'),
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
                  key: ValueKey('reported_users_loading'),
                ),
              )
              : provider.errorMessage != null
              ? Center(
                child: Text(
                  provider.errorMessage!,
                  key: const ValueKey('reported_users_error_message'),
                ),
              )
              : users.isEmpty
              ? Center(
                child: Text(
                  "No ${_selectedStatus.toLowerCase()} users",
                  key: ValueKey(
                    'reported_users_empty_${_selectedStatus.toLowerCase()}',
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final reportedUser = users[index];
                  return ReportedUserCard(
                    key: ValueKey('reported_users_card_$index'),
                    user: reportedUser,
                    onIgnore: () {
                      provider.resolveUserReport(reportedUser.id, "ignore");
                    },
                    onSuspend: () {
                      provider.resolveUserReport(
                        reportedUser.id,
                        "suspend_user",
                      );
                    },
                  );
                },
              ),
    );
  }
}
