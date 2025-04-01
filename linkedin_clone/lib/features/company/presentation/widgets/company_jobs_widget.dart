import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/job.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/job_card_widget.dart';
import 'package:provider/provider.dart';

class CompanyJobsWidget extends StatelessWidget {
  final String userId;
  final String companyId;

  const CompanyJobsWidget({
    Key? key,
    required this.userId,
    required this.companyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final companyProfileProvider = Provider.of<CompanyProvider>(context);

    if (companyProfileProvider.isLoadingJobs) {
      return Center(child: CircularProgressIndicator());
    }

    final List<Job> jobs = companyProfileProvider.jobs;

    if (jobs.isEmpty) {
      return Center(child: Text("No jobs available"));
    }

    jobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));

    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return JobCard(
          job: jobs[index],
          userId: userId,
          companyId: companyId, 
        );
      },
    );
  }
}
