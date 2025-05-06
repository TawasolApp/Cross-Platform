import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';

class JobAnalyticsScreen extends StatefulWidget {
  final CompanyProvider companyProvider;

  JobAnalyticsScreen({required this.companyProvider});

  @override
  _JobAnalyticsScreenState createState() => _JobAnalyticsScreenState();
}

class _JobAnalyticsScreenState extends State<JobAnalyticsScreen> {
  late List<Job> jobs;
  String _selectedSort = "Top Progress"; // Default sorting

  @override
  void initState() {
    super.initState();
    jobs = List.from(widget.companyProvider.jobs);
    _sortJobs();
  }

  void _sortJobs() {
    setState(() {
      if (_selectedSort == "Date Posted") {
        jobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));
      } else if (_selectedSort == "Alphabetical (A-Z)") {
        jobs.sort((a, b) => a.position.compareTo(b.position));
      } else if (_selectedSort == "Top Progress") {
        jobs.sort((a, b) => b.applicantCount.compareTo(a.applicantCount));
      }
    });
  }

  int getMaxApplicantCount() {
    return jobs.isNotEmpty
        ? jobs.map((job) => job.applicantCount).reduce((a, b) => a > b ? a : b)
        : 1;
  }

  Color getProgressBarColor(int applicantCount, int maxApplicantCount) {
    double percentage =
        maxApplicantCount > 0 ? applicantCount / maxApplicantCount : 0.0;
    if (percentage > 0.75) {
      return Colors.green;
    } else if (percentage > 0.5) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxApplicantCount = getMaxApplicantCount();

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Job Analytics")],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "All Jobs with Applicant Counts",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                PopupMenuTheme(
                  data: PopupMenuThemeData(
                    color: Colors.white,
                    textStyle: TextStyle(color: Colors.black),
                  ),
                  child: PopupMenuButton<String>(
                    key: const ValueKey('company_job_analytics_sort_menu_button'),
                    onSelected: (value) {
                      setState(() {
                        _selectedSort = value;
                        _sortJobs();
                      });
                    },
                    offset: Offset(0, screenHeight * 0.04),
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: "Top Progress",
                            child: Text("Top Progress"),
                          ),
                          PopupMenuItem(
                            value: "Date Posted",
                            child: Text("Date Posted"),
                          ),
                          PopupMenuItem(
                            value: "Alphabetical (A-Z)",
                            child: Text("Alphabetical (A-Z)"),
                          ),
                        ],
                    icon: Icon(Icons.sort),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  double progress =
                      maxApplicantCount > 0
                          ? job.applicantCount / maxApplicantCount
                          : 0.0;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 2),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.work_outline,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    job.position,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text("${job.applicantCount} Applicants"),
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[300],
                                color: getProgressBarColor(
                                  job.applicantCount,
                                  maxApplicantCount,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
