// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:linkedin_clone/features/company/domain/entities/job.dart';
// import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';

// class JobAnalyticsScreen extends StatelessWidget {
//   final CompanyProvider companyProvider;

//   JobAnalyticsScreen({required this.companyProvider});

//   @override
//   Widget build(BuildContext context) {
//     if (companyProvider.isLoadingJobs) {
//       return Scaffold(
//         appBar: AppBar(title: Text("Job Analytics")),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final List<Job> jobs = companyProvider.jobs;

//     if (jobs.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(title: Text("Job Analytics")),
//         body: Center(child: Text("No jobs available")),
//       );
//     }

//     print("Jobs in Analytics: ${jobs.length}");

//     // Sort jobs by highest number of applicants and limit to top 5
//     jobs.sort((a, b) => b.applicantCount.compareTo(a.applicantCount));
//     final List<Job> topJobs = jobs.take(5).toList(); // Show only top 5

//     return Scaffold(
//       appBar: AppBar(title: Text("Job Analytics")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Top 5 Jobs with Most Applicants",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Expanded(child: _buildHorizontalBarChart(topJobs)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHorizontalBarChart(List<Job> jobs) {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: jobs.first.applicantCount.toDouble() + 5,
//         barGroups:
//             jobs.take(5).map((job) {
//               return BarChartGroupData(
//                 x: jobs.indexOf(job),
//                 barRods: [
//                   BarChartRodData(
//                     y: job.applicantCount.toDouble(),
//                     width: 25,
//                   ),
//                 ],
//               );
//             }).toList(),
//         titlesData: FlTitlesData(
//           leftTitles: SideTitles(showTitles: true),
//           bottomTitles: SideTitles(showTitles: false),
//         ),
//         gridData: FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//       ),
//     );
//   }
// }
