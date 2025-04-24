import 'package:flutter/material.dart';
import '../../domain/entities/report_entity.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';

class ReportCard extends StatelessWidget {
  final ReportEntity report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AdminProvider>(context, listen: false);

    return Card(
      key: ValueKey('reportCard_${report.id}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Type: ${report.type}",
              style: theme.textTheme.titleMedium,
              key: ValueKey('reportType_${report.id}'),
            ),
            Text(
              "Reason: ${report.reason}",
              key: ValueKey('reportReason_${report.id}'),
            ),
            Text(
              "Status: ${report.status}",
              key: ValueKey('reportStatus_${report.id}'),
            ),
            Text(
              "Reported By: ${report.reportedBy}",
              key: ValueKey('reportedBy_${report.id}'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  key: ValueKey('ignoreBtn_${report.id}'),
                  onPressed: () {
                    provider.resolveReport(report.id, "ignore");
                  },
                  child: const Text("Ignore"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: ValueKey('deleteBtn_${report.id}'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    provider.resolveReport(report.id, "delete_post");
                  },
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
