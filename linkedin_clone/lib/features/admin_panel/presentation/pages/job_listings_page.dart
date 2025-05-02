import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../provider/admin_provider.dart';
import '../widgets/admin_job_card.dart';

class AdminJobListingsPage extends StatefulWidget {
  const AdminJobListingsPage({super.key});

  @override
  State<AdminJobListingsPage> createState() => _AdminJobListingsPageState();
}

class _AdminJobListingsPageState extends State<AdminJobListingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AdminProvider>(context, listen: false);
    provider.fetchJobListings(refresh: true);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        provider.refreshJobs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final allJobs = provider.jobListings;
    final flaggedJobs = allJobs.where((j) => j.status == 'Pending').toList();

    final showJobs = _tabController.index == 0 ? allJobs : flaggedJobs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Jobs"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "All Jobs"), Tab(text: "Flagged")],
        ),
      ),
      body:
          provider.isLoading && provider.jobListings.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async => provider.refreshJobs(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: showJobs.length + (provider.hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == showJobs.length) {
                      // Load more spinner
                      provider.fetchJobListings();
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final job = showJobs[index];
                    return AdminJobCard(
                      job: job,
                      onDelete: () => provider.deleteJob(job.id),
                      onIgnore:
                          job.status == 'Pending'
                              ? () => provider.ignoreJob(job.id)
                              : null,
                    );
                  },
                ),
              ),
    );
  }
}
