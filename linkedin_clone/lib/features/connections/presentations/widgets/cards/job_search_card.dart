import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_card.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_card.dart';
import 'package:provider/provider.dart';

class JobSearchCard extends StatelessWidget {
  final List<Job> jobs;
  SearchProvider? _searchProvider;
  JobSearchCard({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    _searchProvider = Provider.of<SearchProvider>(context);
    final displayedJobs = jobs.length > 3 ? jobs.sublist(0, 3) : jobs;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Text("Jobs", style: Theme.of(context).textTheme.titleLarge),
          ),

          const SizedBox(height: 10),
          Divider(color: Theme.of(context).dividerColor),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:
                  displayedJobs.map((job) {
                    return Column(children: [JobCard(job: job)]);
                  }).toList(),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                _searchProvider?.filterType = FilterType.jobs;
              },
              child: Text(
                "See all jobs",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
