import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_search_provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/saved_jobs_provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/utils/time_ago.dart';

class CompanyJobCard extends StatefulWidget {
  final Job job;
  final String companyId;

  const CompanyJobCard({super.key, required this.job, required this.companyId});

  @override
  _CompanyJobCardState createState() => _CompanyJobCardState();
}

class _CompanyJobCardState extends State<CompanyJobCard> {
  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final companyProvider = Provider.of<CompanyProvider>(context);
    final savedJobsProvider = context.watch<SavedJobsProvider>();
    final isSaved = savedJobsProvider.isSaved(job.id);
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobDetailsScreen(jobId: widget.job.id),
            ),
          );

          if (!mounted) return; 

          if (result == true) {
            await Provider.of<CompanyProvider>(
              context,
              listen: false,
            ).fetchRecentJobs(widget.companyId, reset: true);

            await Provider.of<JobSearchProvider>(
              context,
              listen: false,
            ).fetchJobs(reset: true);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Logo
                  _buildCompanyLogo(context, companyProvider),

                  const SizedBox(width: 10),
                  // Job Info
                  Expanded(child: _buildJobInfo(context)),

                  // Save Button + (Optional Delete Button)
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_add_outlined,
                          color: isSaved ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () async {
                          await savedJobsProvider.toggleSave(job.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                savedJobsProvider.isSaved(job.id)
                                    ? '✅ Job saved'
                                    : '❌ Job removed from saved',
                              ),
                              backgroundColor:
                                  savedJobsProvider.isSaved(job.id)
                                      ? Colors.green
                                      : Colors.orange,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),

                      // Only Admins See Delete Button
                      if (companyProvider.isManager &&
                          !companyProvider.isViewingAsUser)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Delete Job'),
                                    content: const Text(
                                      'Are you sure you want to delete this job?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              final success = await companyProvider.deleteJob(
                                widget.job.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? "Job deleted successfully"
                                        : "Failed to delete job",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Posted Time
              Text(
                timeAgo(widget.job.postedDate),
                style: TextStyle(color: Colors.green[500], fontSize: 12),
              ),

              const SizedBox(height: 10),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(
    BuildContext context,
    CompanyProvider companyProvider,
  ) {
    final logoUrl = companyProvider.company?.logo;

    return logoUrl != null && logoUrl.trim().isNotEmpty
        ? Container(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(
              image: NetworkImage(logoUrl),
              fit: BoxFit.cover,
            ),
          ),
        )
        : Container(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[300],
          ),
          child: const Icon(Icons.business, color: Colors.black),
        );
  }

  Widget _buildJobInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.job.position,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          widget.job.industry,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "${widget.job.location} (${widget.job.locationType})",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
