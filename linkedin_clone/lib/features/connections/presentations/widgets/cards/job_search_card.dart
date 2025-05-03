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
      key: const Key('job_search_card_container'),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        key: const Key('job_search_card_main_column'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            key: const Key('job_search_card_title_padding'),
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Text(
              "Jobs",
              key: const Key('job_search_card_title_text'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(key: Key('job_search_card_title_spacing'), height: 10),
          Divider(
            key: const Key('job_search_card_divider'),
            color: Theme.of(context).dividerColor,
          ),
          Padding(
            key: const Key('job_search_card_jobs_padding'),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              key: const Key('job_search_card_jobs_column'),
              children:
                  displayedJobs.map((job) {
                    final int index = displayedJobs.indexOf(job);
                    return Column(
                      key: Key('job_search_card_job_column_$index'),
                      children: [
                        JobCard(
                          key: Key('job_search_card_job_$index'),
                          job: job,
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
          Center(
            key: const Key('job_search_card_button_center'),
            child: TextButton(
              key: const Key('job_search_card_see_all_button'),
              onPressed: () {
                _searchProvider?.filterType = FilterType.jobs;
              },
              child: Text(
                "See all jobs",
                key: const Key('job_search_card_see_all_text'),
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
