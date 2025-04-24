import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import '../widgets/report_card.dart';
import '../../../feed/presentation/widgets/loading_indicator.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Reported Content")),
      body:
          provider.isLoading
              ? const LoadingIndicator()
              : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!))
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: provider.reports.length,
                itemBuilder: (context, index) {
                  return ReportCard(report: provider.reports[index]);
                },
              ),
    );
  }
}
