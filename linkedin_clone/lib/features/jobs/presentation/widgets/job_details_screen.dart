import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_apply_widget.dart';
import 'package:linkedin_clone/core/utils/number_formatter.dart';
import 'package:linkedin_clone/core/utils/time_ago.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  final bool isManager; 

  const JobDetailsScreen({
    super.key,
    required this.job,
    this.isManager = false, // Default value = false if viewed from 
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool isSaved = false;
  bool isExpanded = false;
  bool showBottomNav = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (_scrollController.offset > 300 && !showBottomNav) {
      setState(() => showBottomNav = true);
    } else if (_scrollController.offset <= 300 && showBottomNav) {
      setState(() => showBottomNav = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Logo + Name
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          job.companyLogo.isNotEmpty
                              ? job.companyLogo
                              : 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/800px-LinkedIn_logo_initials.png',
                        ),
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          job.companyName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Job Position
                  Text(
                    job.position,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),

                  // Location, Time, Applicants
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      children: [
                        TextSpan(
                          text:
                              "${job.location} • ${timeAgo(job.postedDate)} • ",
                        ),
                        TextSpan(
                          text:
                              "${formatNumber(job.applicantCount)} clicked apply",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.green[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tags
                  Row(
                    children: [
                      _tag(job.locationType),
                      const SizedBox(width: 8),
                      _tag(job.employmentType),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Apply / Save Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ApplyForJobWidget(
                                      companyName: job.companyName,
                                      jobId: job.id,
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            "Apply",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            setState(() => isSaved = !isSaved);
                          },
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: Colors.blue,
                          ),
                          label: Text(
                            isSaved ? "Saved" : "Save",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  const SizedBox(height: 12),

                  // Job Description
                  Text(
                    "About the Job",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),

                  // About Company Section
                  Text(
                    "About ${job.companyName}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.companyDescription.isNotEmpty
                        ? job.companyDescription
                        : "No company description available.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          showBottomNav
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ApplyForJobWidget(
                                    companyName: job.companyName,
                                    jobId: job.id,
                                  ),
                            ),
                          );
                        },
                        child: const Text(
                          "Apply",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          setState(() => isSaved = !isSaved);
                        },
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.blue,
                        ),
                        label: Text(
                          isSaved ? "Saved" : "Save",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }

  Widget _tag(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(text, style: const TextStyle(color: Colors.black)),
  );
}
