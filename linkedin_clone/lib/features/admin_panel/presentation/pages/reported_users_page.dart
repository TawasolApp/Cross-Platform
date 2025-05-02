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
        title: const Text("Reported Users"),

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: _selectedStatus,
              underline: const SizedBox(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                  provider.fetchReportedUsers(status: value);
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
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final reportedUser = users[index];

                  return ReportedUserCard(
                    user: reportedUser,
                    onIgnore: () {
                      provider.resolveUserReport(reportedUser.id, "Dismissed");
                    },
                    onSuspend: () {
                      provider.resolveUserReport(reportedUser.id, "Suspend");
                    },
                  );
                },
              ),
    );
  }
}
