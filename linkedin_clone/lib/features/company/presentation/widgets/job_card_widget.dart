import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/job.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/job_details.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/utils/time_ago.dart';

class JobCard extends StatefulWidget {
  final Job job;
  final String userId;
  final String companyId;
  JobCard({required this.job, required this.userId, required this.companyId});

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(
      context,
      listen: false,
    );

    return Material(
      color: Colors.white, // Color to something visible for ripple effect
      child: InkWell(
        onTap: () {
          print("Tapped on job: ${widget.job.id}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => JobDetailsScreen(
                    job: widget.job,
                    companyProvider: companyProvider,
                    userId: widget.userId,
                    companyId: widget.companyId,
                  ),
            ),
          );
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
                  (companyProvider.hasValidLogo)
                      ? Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.1, 
                        height:
                            MediaQuery.of(context).size.width *
                            0.1, 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: NetworkImage(
                              companyProvider.company!.logo ??
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/800px-LinkedIn_logo_initials.png', // Default LinkedIn logo
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      : Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.1,
                        height:
                            MediaQuery.of(context).size.width *
                            0.1, 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color:
                              Colors.grey[300], 
                        ),
                        child: Icon(
                          Icons.business,
                          color: Colors.black, 
                          size:
                              MediaQuery.of(context).size.width *
                              0.1, 
                        ),
                      ),
                  SizedBox(width: 10),
                  SizedBox(width: 10),
                  // Job Title and Company Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Title
                        Text(
                          widget.job.position,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.job.company,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${widget.job.location} (${widget.job.locationType})",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // IconButton (for saving the job)
                  IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_add_outlined,
                    ),
                    onPressed: () {
                      // Toggle the bookmark status
                      setState(() {
                        isBookmarked = !isBookmarked;
                      });
                      // Show Snackbar with success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isBookmarked
                                ? "Job saved"
                                : "Job removed from saved",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                              isBookmarked
                                  ? const Color.fromARGB(238, 72, 165, 75)
                                  : const Color.fromARGB(223, 210, 58, 47),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      print(
                        "Job ${isBookmarked ? 'saved' : 'removed'}: ${widget.job.id}",
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 6),
              // Posted Time
              Text(
                timeAgo(widget.job.postedDate),
                style: TextStyle(color: Colors.green[500], fontSize: 12),
              ),
              SizedBox(height: 10),
              Divider(), // Adds a subtle divider between job listings
            ],
          ),
        ),
      ),
    );
  }
}
