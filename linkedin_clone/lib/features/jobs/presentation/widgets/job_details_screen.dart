import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';
import 'package:linkedin_clone/features/jobs/presentation/pages/job_applicants_page.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_details_provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/saved_jobs_provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_apply_widget.dart';
import 'package:linkedin_clone/core/utils/number_formatter.dart';
import 'package:linkedin_clone/core/utils/time_ago.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobId;
  const JobDetailsScreen({super.key, required this.jobId});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool isSaved = false;
  bool isExpanded = false;
  bool showBottomNav = false;
  bool _canSeeApplicants = false;
  late ScrollController _scrollController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    Future.microtask(() async {
      final tokenCompanyId = await TokenService.getCompanyId();
      final tokenIsCompany = await TokenService.getIsCompany();
      // Fetch job details
      final jobProvider = Provider.of<JobDetailsProvider>(
        context,
        listen: false,
      );
      await jobProvider.fetchJob(widget.jobId);
      final job = Provider.of<JobDetailsProvider>(context, listen: false).job;
      if (job != null) {
        print('Job Status: ${job.status}');
        if (job.status.toLowerCase() == 'accepted') {
          _confettiController.play();
        }
      }
      if (tokenCompanyId != null &&
          tokenCompanyId == job?.companyId &&
          tokenIsCompany == true) {
        setState(() {
          _canSeeApplicants = true;
        });
      }
      // 🎉 Play confetti if accepted
      if (job?.status.toLowerCase() == 'accepted') {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _confettiController.dispose();
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
    final jobProvider = context.watch<JobDetailsProvider>();

    if (jobProvider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.work_outline, size: 60, color: Colors.blue),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 16),
              Text(
                "Fetching job details...",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      );
    }

    if (jobProvider.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 12),
              Text(
                jobProvider.error!,
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const ValueKey('job_details_retry_button'),

                onPressed: () {
                  context.read<JobDetailsProvider>().fetchJob(widget.jobId);
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final job = jobProvider.job;

    if (job == null) {
      return const Center(child: Text('Job not found.'));
    }
    final savedJobsProvider = context.watch<SavedJobsProvider>();
    final isSaved = savedJobsProvider.isSaved(job.id);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              key: const ValueKey('job_details_back_button'),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CompanyProfileScreen(
                                        companyId: job.companyId,
                                      ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  job.companyLogo.isNotEmpty
                                      ? NetworkImage(job.companyLogo)
                                      : null,
                              child:
                                  job.companyLogo.isEmpty
                                      ? const Icon(
                                        Icons.business,
                                        size: 24,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.companyName,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),

                          if (_canSeeApplicants)
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Navigating to applicants screen...',
                                    ),
                                    duration: Duration(milliseconds: 400),
                                  ),
                                );

                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                ApplicantsScreen(jobId: job.id),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.people_alt, color: Colors.green),
                                  SizedBox(width: 6),
                                  Text(
                                    "See Applicants",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[600]),
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
                          IconButton(
                            key: const ValueKey('job_details_share_button'),
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              final jobUrl =
                                  'https://tawasolapp.me/jobs/${job.id}';
                              Share.share(
                                'Check out this job opportunity: $jobUrl',
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Apply / Save Buttons
                      Row(
                        children: [
                          Expanded(
                            child:
                                (job.status.isNotEmpty)
                                    ? _buildStatusBadge(job.status)
                                    : ElevatedButton(
                                      key: const ValueKey('job_details_apply_button'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        backgroundColor: Colors.blue[700],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => ApplyForJobWidget(
                                                  companyName: job.companyName,
                                                  jobId: job.id,
                                                ),
                                          ),
                                        );

                                        if (result == true) {
                                          Navigator.pop(context, true);
                                        }
                                      },

                                      child: const Text(
                                        "Apply",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                          ),

                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              key: const ValueKey('job_details_save_button'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
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
                              icon: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
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
                          child:
                              (job.status != null && job.status!.isNotEmpty)
                                  ? _buildStatusBadge(job.status!)
                                  : ElevatedButton(
                                    key: const ValueKey('job_details_apply_button'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      backgroundColor: Colors.blue[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => ApplyForJobWidget(
                                                companyName: job.companyName,
                                                jobId: job.id,
                                              ),
                                        ),
                                      );
                                      if (result == true) {
                                        await Provider.of<CompanyProvider>(
                                          context,
                                          listen: false,
                                        ).fetchRecentJobs(job.companyId);
                                      }
                                    },
                                    child: const Text(
                                      "Apply",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                        ),
                        const SizedBox(width: 12),
                        // Save button remains unchanged
                        Expanded(
                          child: OutlinedButton.icon(
                            key: const ValueKey('job_details_save_button'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
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
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            maxBlastForce: 30,
            minBlastForce: 5,
            numberOfParticles: 8,
            gravity: 0.2,
            emissionFrequency: 0.03,
            shouldLoop: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'accepted':
        color = Colors.green;
        label = 'Accepted';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rejected';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
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
