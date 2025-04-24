import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import '../widgets/job_listing_card.dart';
import '../../../feed/presentation/widgets/loading_indicator.dart';

class JobListingsPage extends StatelessWidget {
  const JobListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Flagged Job Listings")),
      body:
          provider.isLoading
              ? const LoadingIndicator()
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: provider.jobListings.length,
                itemBuilder: (context, index) {
                  return JobListingCard(job: provider.jobListings[index]);
                },
              ),
    );
  }
}
