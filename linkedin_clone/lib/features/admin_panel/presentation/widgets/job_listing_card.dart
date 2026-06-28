import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/job_listing_entity.dart';
import '../provider/admin_provider.dart';

class JobListingCard extends StatelessWidget {
  final JobListingEntity job;

  const JobListingCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context, listen: false);

    return Card(
      key: ValueKey('jobCard_${job.id}'),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${job.title}",
              key: ValueKey('jobTitle_${job.id}'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Company: ${job.company}",
              key: ValueKey('jobCompany_${job.id}'),
            ),
            const SizedBox(height: 4),
            Text("Reason: ${job.reason}", key: ValueKey('jobReason_${job.id}')),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  key: ValueKey('deleteJobBtn_${job.id}'),
                  onPressed: () => provider.deleteJob(job.id),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  key: ValueKey('ignoreJobBtn_${job.id}'),
                  onPressed: () => provider.ignoreJob(job.id),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Ignore"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../domain/entities/job_listing_entity.dart';
// import '../provider/admin_provider.dart';

// class JobListingCard extends StatelessWidget {
//   final JobListingEntity job;

//   const JobListingCard({super.key, required this.job});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<AdminProvider>(context, listen: false);

//     return Card(
//       key: ValueKey('jobCard_${job.id}'),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Title: ${job.title}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//               key: ValueKey('jobTitle_${job.id}'),
//             ),
//             Text(
//               "Company: ${job.company}",
//               key: ValueKey('jobCompany_${job.id}'),
//             ),
//             Text("Reason: ${job.reason}", key: ValueKey('jobReason_${job.id}')),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               key: ValueKey('deleteJobBtn_${job.id}'),
//               onPressed: () => provider.deleteJob(job.id),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               child: const Text("Delete"),
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton(
//               key: ValueKey('ignoreJobBtn_${job.id}'),
//               onPressed: () => provider.ignoreJob(job.id),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
//               child: const Text("Ignore"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
