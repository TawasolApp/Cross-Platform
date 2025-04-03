import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/job.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_add_job_screen.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_job_analytics_screen.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/job_card_widget.dart';
import 'package:provider/provider.dart';

class CompanyJobsWidget extends StatelessWidget {
  final String userId;
  final String companyId;
  final VoidCallback? onEditPressed;
  final VoidCallback? onAnalyticsPressed;

  const CompanyJobsWidget({
    Key? key,
    required this.userId,
    required this.companyId,
    this.onEditPressed,
    this.onAnalyticsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);

    if (companyProvider.isLoadingJobs) {
      return Center(child: CircularProgressIndicator());
    }

    final List<Job> jobs = companyProvider.jobs;
    if (jobs.isEmpty) {
      return Center(child: Text("No jobs available"));
    }
    print("Jobs in Jobs Tab: ${companyProvider.jobs.length}");

    jobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (companyProvider.isAdmin && !companyProvider.isViewingAsUser)
          // Row containing "Job Analytics" and "Post a Job Opening"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed:
                      onAnalyticsPressed ??
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
                    style: TextStyle(color: Color.fromARGB(255, 23, 104, 170)),
                  ),
                ),
                TextButton.icon(
                  onPressed:
                      onEditPressed ??
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddJobScreen(),
                          ),
                        );
                      },
                  icon: Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 23, 104, 170),
                  ),
                  label: Text(
                    "Post a Job Opening",
                    style: TextStyle(color: Color.fromARGB(255, 23, 104, 170)),
                  ),
                ),
              ],
            ),
          ),

        // "Jobs Posted" with Padding
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

        // Job List
        Expanded(
          child: ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return JobCard(
                job: jobs[index],
                userId: userId,
                companyId: companyId,
              );
            },
          ),
        ),
      ],
    );
  }
}
