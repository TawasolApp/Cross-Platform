import 'package:flutter/material.dart';
import '../../../jobs/domain/entities/job_entity.dart';

class AdminJobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onDelete;
  final VoidCallback? onIgnore;

  const AdminJobCard({
    super.key,
    required this.job,
    required this.onDelete,
    this.onIgnore,
  });

  @override
  Widget build(BuildContext context) {
    final isFlagged =
        job.status == "Pending"; // Or job.isFlagged if using that field

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            isFlagged
                ? Border.all(color: Colors.redAccent, width: 1.5)
                : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(job.companyLogo),
            radius: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.position,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(job.companyName, style: const TextStyle(fontSize: 13)),
                Text(job.companyLocation, style: const TextStyle(fontSize: 13)),
                if (isFlagged)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Icon(Icons.flag, size: 14, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          "Flagged",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${job.postedDate.month}/${job.postedDate.day}/${job.postedDate.year}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (isFlagged)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: OutlinedButton(
                        onPressed: onIgnore,
                        child: const Text("Ignore"),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.red.shade300),
                      ),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
