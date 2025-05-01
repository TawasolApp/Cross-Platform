import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/core/utils/time_ago.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/saved_jobs_provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_details_screen.dart';
import 'package:provider/provider.dart';

class JobCard extends StatefulWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final savedJobsProvider = context.watch<SavedJobsProvider>();
    final isSaved = savedJobsProvider.isSaved(job.id);
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => JobDetailsScreen(job: job)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Company logo
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      job.companyLogo.isNotEmpty
                          ? job.companyLogo
                          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/800px-LinkedIn_logo_initials.png',
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(width: 12),
                  // Job title and company name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.position,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.companyName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${job.location} • ${job.locationType}",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  // Save/Unsave Job
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      color: isSaved ? Colors.blue : Colors.grey[700],
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
                ],
              ),
              const SizedBox(height: 10),
              // Industry + posted date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.industry,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    timeAgo(job.postedDate),
                    style: TextStyle(color: Colors.green[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
