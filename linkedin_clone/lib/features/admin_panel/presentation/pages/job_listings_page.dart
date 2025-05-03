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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(
        context,
        listen: false,
      ).fetchJobListings(refresh: true);
    });

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<AdminProvider>(context, listen: false).refreshJobs();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final allJobs = provider.jobListings;
    final flaggedJobs = allJobs.where((j) => j.isFlagged == true).toList();
    final showJobs = _tabController.index == 0 ? allJobs : flaggedJobs;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Jobs",
          key: ValueKey('admin_jobs_appbar_title'),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(key: ValueKey('admin_jobs_tab_all'), text: "All Jobs"),
            Tab(key: ValueKey('admin_jobs_tab_flagged'), text: "Flagged"),
          ],
        ),
      ),
      body:
          provider.isLoading && provider.jobListings.isEmpty
              ? const Center(
                child: CircularProgressIndicator(
                  key: ValueKey('admin_jobs_loading_indicator'),
                ),
              )
              : RefreshIndicator(
                onRefresh: () async => provider.refreshJobs(),
                child:
                    showJobs.isEmpty
                        ? Center(
                          child: Text(
                            _tabController.index == 1
                                ? "No flagged jobs"
                                : "No jobs available",
                            key: ValueKey(
                              _tabController.index == 1
                                  ? 'admin_jobs_empty_flagged'
                                  : 'admin_jobs_empty_all',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          key: const ValueKey('admin_jobs_list'),
                          padding: const EdgeInsets.all(12),
                          itemCount:
                              showJobs.length + (provider.hasMoreData ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == showJobs.length) {
                              Provider.of<AdminProvider>(
                                context,
                                listen: false,
                              ).fetchJobListings();
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    key: ValueKey(
                                      'admin_jobs_pagination_loader',
                                    ),
                                  ),
                                ),
                              );
                            }

                            final job = showJobs[index];
                            return AdminJobCard(
                              key: ValueKey('admin_jobs_card_${job.id}'),
                              job: job,
                              onDelete: () => provider.deleteJob(job.id),
                              onIgnore:
                                  job.isFlagged
                                      ? () => provider.ignoreJob(job.id)
                                      : null,
                            );
                          },
                        ),
              ),
    );
  }
}
