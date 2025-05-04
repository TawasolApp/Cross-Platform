import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_job_card_widget.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_add_job_screen.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_job_analytics_screen.dart';
import 'package:provider/provider.dart';

class CompanyJobsWidget extends StatefulWidget {
  final String companyId;
  final VoidCallback? onEditPressed;
  final VoidCallback? onAnalyticsPressed;

  const CompanyJobsWidget({
    Key? key,
    required this.companyId,
    this.onEditPressed,
    this.onAnalyticsPressed,
  }) : super(key: key);

  @override
  _CompanyJobsWidgetState createState() => _CompanyJobsWidgetState();
}

class _CompanyJobsWidgetState extends State<CompanyJobsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
        if (companyProvider.isLoadingJobs && companyProvider.jobs.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        final List<Job> jobs = companyProvider.jobs;
        print("Jobs in Jobs Tab: ${companyProvider.jobs.length}");

        // Sort jobs by posted date
        jobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (companyProvider.isManager && !companyProvider.isViewingAsUser)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      key: const ValueKey('company_jobs_analytics_button'),

                      onPressed:
                          widget.onAnalyticsPressed ??
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => JobAnalyticsScreen(
                                      companyProvider: companyProvider,
                                    ),
                              ),
                            );
                          },
                      icon: Icon(
                        Icons.analytics,
                        color: Color.fromARGB(255, 23, 104, 170),
                      ),
                      label: Text(
                        "Job Analytics",
                        style: TextStyle(
                          color: Color.fromARGB(255, 23, 104, 170),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      key: const ValueKey('company_jobs_add_job_button'),
                      onPressed:
                          widget.onEditPressed ??
                          () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AddJobScreen(
                                      companyId: widget.companyId,
                                    ),
                              ),
                            );
                            if (result == true) {
                              companyProvider.resetJobs();
                              companyProvider.fetchRecentJobs(widget.companyId);
                            }
                          },
                      icon: Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 23, 104, 170),
                      ),
                      label: Text(
                        "Post a Job Opening",
                        style: TextStyle(
                          color: Color.fromARGB(255, 23, 104, 170),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Jobs Posted",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  jobs.isEmpty
                      ? (companyProvider.isManager &&
                              !companyProvider.isViewingAsUser
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.work_outline,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Jobs Posted Yet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start posting job openings to attract top talent.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                          : Center(
                            child: Text(
                              'No jobs available.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ),
                            ),
                          ))
                      : ListView.builder(
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          return CompanyJobCard(
                            job: jobs[index],
                            companyId: widget.companyId,
                          );
                        },
                      ),
            ),
            // "Load More Jobs" Button
            if (!companyProvider.isLoadingJobs &&
                !companyProvider.isAllJobsLoaded &&
                jobs.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  key: const ValueKey('company_jobs_load_more_button'),
                  onPressed:
                      () => companyProvider.loadMoreJobs(widget.companyId),
                  child: Text("Load More Jobs"),
                ),
              )
            else if (companyProvider.isAllJobsLoaded && jobs.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(child: const Text('No more jobs available.')),
              )
            else if (companyProvider.isLoadingJobs && jobs.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
