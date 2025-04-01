import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/utils/number_formatter.dart';
import 'package:linkedin_clone/features/company/domain/entities/job.dart';
import 'package:linkedin_clone/core/utils/time_ago.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/job_apply_widget.dart';
import 'package:provider/provider.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  final CompanyProvider companyProvider;
  final String userId;
  final String companyId;

  const JobDetailsScreen({
    Key? key,
    required this.job,
    required this.companyProvider,
    required this.userId,
    required this.companyId,
  }) : super(key: key);

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

final ScrollController _scrollController = ScrollController();

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
    // Only dispose of the controller when it's no longer needed.
    _scrollController.removeListener(_onScroll);
    _scrollController
        .dispose(); // Dispose the controller properly when the screen is removed.
    super.dispose();
  }

  void _onScroll() {
    if (!mounted)
      return; // Check if the widget is still mounted before calling setState
    if (_scrollController.offset > 300 && !showBottomNav) {
      setState(() {
        showBottomNav = true;
      });
    } else if (_scrollController.offset <= 300 && showBottomNav) {
      setState(() {
        showBottomNav = false;
      });
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
          onPressed: () => Navigator.pop(context), // Closes the screen
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Display company logo and name if available
              if (widget.companyProvider.company != null &&
                  widget.companyProvider.company!.logo != null)
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.companyProvider.company!.logo ??
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/800px-LinkedIn_logo_initials.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.companyProvider.company!.name ?? 'Unknown Company',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              SizedBox(height: 8),
              // ✅ Job position
              Text(
                widget.job.position,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              // ✅ Company name
              Text(
                "Company: ${widget.job.company}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              // ✅ Job location, post date, and applicants count
              Text(
                "${widget.job.location} • ${timeAgo(widget.job.postedDate)} • ${formatNumber(widget.job.applicantCount)} people clicked apply",
                style: TextStyle(color: Colors.grey[500]),
              ),
              SizedBox(height: 16),
              // ✅ Location and employment type
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.job.locationType,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.job.employmentType,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17),
              // ✅ Apply and Save buttons
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
                            builder: (context) => ApplyForJobWidget(companyName:widget.companyProvider.company!.name),
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
                          //TODO: Save the job in the job module
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
              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 12),
              // ✅ Job Description
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

              // ✅ About the company
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
                  Text(
                    "About ${widget.companyProvider.company?.name ?? 'Company'}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final textSpan = TextSpan(
                    text:
                        widget.companyProvider.company?.overview ??
                        "No company overview available.",
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
                            ? widget.companyProvider.company?.overview ??
                                "No company overview available."
                            : widget.companyProvider.company?.overview
                                    ?.split(" ")
                                    .take(40)
                                    .join(" ") ??
                                "No company overview available.",
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
                            foregroundColor:
                                Colors.grey[600], // Change this color
                          ),
                          child: Text(
                            isExpanded ? "See Less" : "See More",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ), // Optional styling
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
                        onPressed: () {},
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
}
