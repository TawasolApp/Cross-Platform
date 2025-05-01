import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/application_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class JobApplicantCard extends StatelessWidget {
  final ApplicationEntity applicant;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const JobApplicantCard({
    Key? key,
    required this.applicant,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Profile section
            Row(
              children: [
                applicant.applicantPicture.isNotEmpty
                    ? CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(applicant.applicantPicture),
                      backgroundColor: Colors.grey[300],
                    )
                    : CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.applicantName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        applicant.applicantHeadline,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        applicant.applicantEmail,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey[300]),
            const SizedBox(height: 16),

            // Resume button
            if (applicant.resumeUrl.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final modifiedUrl = applicant.resumeUrl.replaceAll(
                      '.pdf',
                      '',
                    );
                    final googleViewerUrl =
                        'https://drive.google.com/viewerng/viewer?embedded=true&url=${Uri.encodeComponent(modifiedUrl)}';

                    if (await canLaunchUrl(Uri.parse(googleViewerUrl))) {
                      await launchUrl(
                        Uri.parse(googleViewerUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open resume')),
                      );
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('View Resume'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[700],
                    side: BorderSide(color: Colors.blue.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 14),

            // Status label
            Row(
              children: [
                const Text(
                  'Application Status: ',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  applicant.status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        applicant.status == "Accepted"
                            ? Colors.green
                            : applicant.status == "Rejected"
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Action buttons
            if (applicant.status == "Pending") ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onAccept,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
