import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';

import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_card.dart';
import 'package:provider/provider.dart';

class JobSearchBody extends StatefulWidget {
  final String query;

  const JobSearchBody({super.key, required this.query});

  @override
  State<JobSearchBody> createState() => _JobSearchBodyState();
}

class _JobSearchBodyState extends State<JobSearchBody> {
  late ScrollController _scrollController;
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchProvider = Provider.of<SearchProvider>(context);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_searchProvider.hasMoreJobs && !_searchProvider.isBusy) {
        _searchProvider.performSearchJobs(searchWord: widget.query);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Job> jobs = _searchProvider.searchResultsJobs;

    return ListView.builder(
      key: const Key('key_jobsearch_listview'),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: jobs.length + 1,
      itemBuilder: (context, index) {
        if (index < jobs.length) {
          final job = jobs[index];
          return Column(
            key: Key('key_jobsearch_column_$index'),
            children: [
              JobCard(key: Key('key_jobsearch_card_$index'), job: job),
            ],
          );
        } else {
          return _searchProvider.isBusy
              ? Padding(
                key: const Key('key_jobsearch_loading_container'),
                padding: const EdgeInsets.all(16),
                child: Center(
                  key: const Key('key_jobsearch_loading_center'),
                  child: CircularProgressIndicator(
                    key: const Key('key_jobsearch_loading_indicator'),
                  ),
                ),
              )
              : SizedBox(
                key: const Key('key_jobsearch_bottom_spacer'),
                height: 30,
              );
        }
      },
    );
  }
}
