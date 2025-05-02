import 'package:flutter/material.dart';
import '../../domain/entities/reported_post_entity.dart';

class ReportedPostCard extends StatelessWidget {
  final ReportedPost post;
  final VoidCallback? onIgnore;
  final VoidCallback? onDelete;
  final VoidCallback? onSuspendUser;

  const ReportedPostCard({
    super.key,
    required this.post,
    this.onIgnore,
    this.onDelete,
    this.onSuspendUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage:
                    post.postAuthorAvatar != null
                        ? NetworkImage(post.postAuthorAvatar!)
                        : null,
                child:
                    post.postAuthorAvatar == null
                        ? const Icon(Icons.person)
                        : null,
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.postAuthor,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post.postAuthorRole,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(post.postContent),
                    if (post.postMedia != null) const SizedBox(height: 6),
                    if (post.postMedia != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          post.postMedia!,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Report Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "REPORT DETAILS",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        post.reporterAvatar != null
                            ? NetworkImage(post.reporterAvatar!)
                            : null,
                    child:
                        post.reporterAvatar == null
                            ? const Icon(Icons.person)
                            : null,
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    post.reportedBy,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  _buildStatusBadge(post.status),
                ],
              ),
              const SizedBox(height: 8),
              Text("Reason: ${post.reason}"),
              Text(
                "Reported at ${_formatDateTime(post.reportedAt)}",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (post.status == "Pending")
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Delete Post"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onIgnore,
                    child: const Text("Ignore"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSuspendUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Suspend User"),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case "Pending":
        color = Colors.amber;
        break;
      case "Actioned":
        color = Colors.green;
        break;
      case "Dismissed":
        color = Colors.grey;
        break;
      default:
        color = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.month}/${dt.day}/${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
  }
}
