import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/job.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_add_job_screen.dart'
    as add_job_screen;
import 'package:linkedin_clone/features/company/presentation/screens/company_add_job_screen.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/job_card_widget.dart';
import 'package:provider/provider.dart';

class CompanyJobsWidget extends StatelessWidget {
  final String userId;
  final String companyId;
  final VoidCallback? onEditPressed;

  const CompanyJobsWidget({
    Key? key,
    required this.userId,
    required this.companyId,
    this.onEditPressed,
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

    jobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jobs Posted",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (companyProvider.isAdmin && companyProvider.isViewingAsUser==false ) // Show button only if user is admin and admin view
                TextButton.icon(
                  onPressed: onEditPressed ??
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
                    color: const Color.fromARGB(255, 23, 104, 170),
                  ),
                  label: Text(
                    "Post a Job Opening",
                    style: TextStyle(color: Color.fromARGB(255, 23, 104, 170)),
                  ),
                ),
            ],
          ),
        ),
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
