import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/job_details.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';

class RecentJobsWidget extends StatelessWidget {
  final String userId;

  const RecentJobsWidget({Key? key, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
        if (companyProvider.isLoadingJobs) {
          return Center(child: CircularProgressIndicator());
        }

        if (companyProvider.jobs.isEmpty) {
          return Center(child: Text("No recent jobs available."));
        }

        // Sort jobs by postedAt date (Descending order, newest first)
        final sortedJobs = List.from(companyProvider.jobs)
          ..sort((a, b) => b.postedDate.compareTo(a.postedDate));

        // Get the top 2 most recent jobs
        final topRecentJobs = sortedJobs.take(2).toList();

        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: topRecentJobs.length, // Only top 2 jobs
              itemBuilder: (context, index) {
                final job = topRecentJobs[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Company Logo Placeholder
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            companyProvider.company?.logo ??
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/800px-LinkedIn_logo_initials.png',
                          ),
                        ),
                        SizedBox(width: 12),

                        // Job Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.position,
                                style: Theme.of(context).textTheme.labelLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                job.location,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(height: 6),
                            ],
                          ),
                        ),

                        // Apply Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => JobDetailsScreen(
                                      job: job, 
                                      companyProvider: companyProvider,
                                      companyId:
                                          companyProvider.company?.companyId ??
                                          '',
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              47,
                              102,
                              174,
                            ),
                          ),
                          child: Text(
                            "Apply",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 12), // Add space between jobs and button
            // Show All Jobs Button
            Center(
              child: SizedBox(
                width: double.infinity, // Take full width
                child: TextButton(
                  onPressed: () {
                    DefaultTabController.of(
                      context,
                    ).animateTo(3); // Index 3 for "Jobs" tab
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Show all jobs",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward, color: Colors.grey[700]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
