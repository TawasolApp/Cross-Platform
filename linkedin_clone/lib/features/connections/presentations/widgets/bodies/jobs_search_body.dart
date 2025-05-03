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
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: jobs.length + 1,
      itemBuilder: (context, index) {
        if (index < jobs.length) {
          final job = jobs[index];
          return Column(
            children: [
              JobCard(job: job),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          );
        } else {
          return _searchProvider.isBusy
              ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
              : const SizedBox(height: 30);
        }
      },
    );
  }
}
