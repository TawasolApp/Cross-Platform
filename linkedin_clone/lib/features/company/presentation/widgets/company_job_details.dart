import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/utils/number_formatter.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/core/utils/time_ago.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/jobs/presentation/pages/job_applicants_page.dart';
import 'package:linkedin_clone/features/jobs/presentation/widgets/job_apply_widget.dart';

class CompanyJobDetailsScreen extends StatefulWidget {
  final Job job;
  final CompanyProvider companyProvider;
  final String companyId;
  final bool isManager;

  CompanyJobDetailsScreen({
    super.key,
    required this.job,
    required this.companyProvider,
    required this.companyId,
    this.isManager = false, // Default value = false if viewed from
  });

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<CompanyJobDetailsScreen> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Info
                    Row(
                      children: [
                        widget.companyProvider.hasValidLogo
                            ? Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.companyProvider.company?.logo ??
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/800px-LinkedIn_logo_initials.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                            : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey[300],
                              ),
                              child: Icon(Icons.business, size: 30),
                            ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.companyProvider.company?.name ??
                                'Unknown Company',
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Job Title
                    Text(
                      widget.job.position,
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),

                    // Job Details
                    Text(
                      "${widget.job.location} • ${timeAgo(widget.job.postedDate)} • ${formatNumber(widget.job.applicantCount)} people clicked apply",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    SizedBox(height: 16),

                    // Tags
                    Row(
                      children: [
                        _tag(widget.job.locationType),
                        SizedBox(width: 8),
                        _tag(widget.job.employmentType),
                      ],
                    ),
                    SizedBox(height: 17),

                    // Apply & Save Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
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
                                        jobId: widget.job.id,
                                        companyName:
                                            widget
                                                .companyProvider
                                                .company
                                                ?.name ??
                                            'Unknown Company',
                                      ),
                                ),
                              );
                            },
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.blue),
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
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    SizedBox(height: 12),
                    const SizedBox(height: 16),
                  if(widget.isManager)
                    // See Applicants Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Navigating to applicants screen...'),
                            duration: Duration(
                              milliseconds: 500,
                            ), // Optional: make it very fast
                          ),
                        );

                        // Push after showing the SnackBar
                        Future.delayed(Duration(milliseconds: 500), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ApplicantsScreen(jobId: widget.job.id),
                            ),
                          );
                        });
                      },
                      child: const Center(
                        child: Text(
                          "See Applicants",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    // Job Description
                    Text(
                      "About the job",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.job.description ?? "No job description available.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 16),

                    // About the Company
                    Row(
                      children: [
                        if (widget.companyProvider.company?.logo != null)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget.companyProvider.company!.logo!,
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "About ${widget.companyProvider.company?.name ?? 'Company'}",
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Expandable Overview
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final text =
                            widget.companyProvider.company?.overview ??
                            "No company overview available.";
                        final textSpan = TextSpan(
                          text: text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                        final textPainter = TextPainter(
                          text: textSpan,
                          maxLines: 6,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: constraints.maxWidth);
                        final isOverflowing = textPainter.didExceedMaxLines;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isExpanded
                                  ? text
                                  : text.split(" ").take(40).join(" "),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            if (isOverflowing)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[600],
                                ),
                                child: Text(
                                  isExpanded ? "See Less" : "See More",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar:
          showBottomNav
              ? Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
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
                                    jobId: widget.job.id,
                                    companyName:
                                        widget.companyProvider.company?.name ??
                                        'Unknown Company',
                                  ),
                            ),
                          );
                        },
                        child: Text(
                          "Apply",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSaved = !isSaved;
                          });
                        },
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.blue,
                        ),
                        label: Text(
                          isSaved ? "Saved" : "Save",
                          style: TextStyle(fontSize: 16, color: Colors.blue),
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
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(text, style: TextStyle(color: Colors.black)),
  );
}
