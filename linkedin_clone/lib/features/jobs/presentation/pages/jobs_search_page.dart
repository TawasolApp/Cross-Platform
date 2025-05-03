import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/presentation/pages/jobs_filter_page.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_card.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_search_provider.dart';

class JobSearchPage extends StatefulWidget {
  const JobSearchPage({super.key});

  @override
  _JobSearchPageState createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<JobSearchProvider>(context, listen: false);
      provider.fetchJobs(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobSearchProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // 🔍 Search + Filters
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Search',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const ValueKey('company_add_admin_field'),

                    controller: _searchController,
                    onChanged: (value) {
                      Future.microtask(() {
                        provider.setFilters(keyword: value.trim());
                        provider.fetchJobs(reset: true);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search jobs...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      key: const ValueKey('job_search_filter_button'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => JobFilterScreen(
                                  initialFilters: {
                                    'location': provider.location,
                                    'industry': provider.industry,
                                    'experienceLevel': provider.experienceLevel,
                                    'company': provider.company,
                                    'minSalary': provider.minSalary,
                                    'maxSalary': provider.maxSalary,
                                  },
                                ),
                          ),
                        );

                        if (result is Map<String, dynamic>) {
                          provider.setFilters(
                            keyword: _searchController.text.trim(),
                            location: result['location'],
                            industry: result['industry'],
                            experienceLevel: result['experienceLevel'],
                            company: result['company'],
                            minSalary: result['minSalary'],
                            maxSalary: result['maxSalary'],
                          );
                          provider.fetchJobs(reset: true);
                        }
                      },
                      icon: const Icon(Icons.tune),
                      label: const Text("Filters"),
                    ),
                  ),
                ],
              ),
            ),

            // 🔄 Job Results List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  provider.fetchJobs(reset: true);
                },
                child: Builder(
                  builder: (_) {
                    if (provider.isLoading && provider.jobs.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.jobs.isEmpty) {
                      return const Center(child: Text('No jobs found.'));
                    }

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: provider.jobs.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index < provider.jobs.length) {
                          final job = provider.jobs[index];
                          return JobCard(job: job);
                        } else if (provider.isAllLoaded) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text('No more jobs available.'),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child:
                                  provider.isLoading
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                        key: const ValueKey(
                                          'load_more_jobs_button',
                                        ),

                                        onPressed: () {
                                          provider.loadMoreJobs();
                                        },
                                        child: const Text('Load More'),
                                      ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
