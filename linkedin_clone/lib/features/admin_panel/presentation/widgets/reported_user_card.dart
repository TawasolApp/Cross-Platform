import 'package:flutter/material.dart';
import '../../domain/entities/reported_user_entity.dart';

class ReportedUserCard extends StatelessWidget {
  final ReportedUser user;
  final VoidCallback? onIgnore;
  final VoidCallback? onSuspend;

  const ReportedUserCard({
    super.key,
    required this.user,
    this.onIgnore,
    this.onSuspend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: ValueKey('reportedUserCard_${user.id}'),
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
          // User & Reporter blocks
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReporterBlock(
                key: ValueKey('reportedUserBlock_${user.id}'),
                label: "REPORTED USER",
                name: user.reportedUser,
                role: user.reportedUserRole,
                avatarUrl: user.reportedUserAvatar,
              ),
              const SizedBox(height: 12),
              _buildReporterBlock(
                key: ValueKey('reporterBlock_${user.id}'),
                label: "REPORTED BY",
                name: user.reportedBy,
                role: null,
                avatarUrl: user.reporterAvatar,
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text("REASON", style: theme.textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(
            user.reason,
            key: ValueKey('reportReason_${user.id}'),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            "Reported at ${_formatDateTime(user.reportedAt)}",
            key: ValueKey('reportTimestamp_${user.id}'),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBadge(user.status),
                  if (user.status == "Pending") ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: availableWidth * 0.45,
                          child: OutlinedButton(
                            key: ValueKey('ignoreUserBtn_${user.id}'),
                            onPressed: onIgnore,
                            child: const Text("Ignore"),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: availableWidth * 0.45,
                          child: ElevatedButton(
                            key: ValueKey('suspendUserBtn_${user.id}'),
                            onPressed: onSuspend,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("Suspend User"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReporterBlock({
    required Key key,
    required String label,
    required String name,
    required String? role,
    required String? avatarUrl,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            CircleAvatar(
              key: ValueKey('${label.replaceAll(' ', '')}_avatar'),
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null ? const Icon(Icons.person) : null,
              radius: 18,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  key: ValueKey('${label.replaceAll(' ', '')}_name'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (role != null)
                  Text(
                    role,
                    key: ValueKey('${label.replaceAll(' ', '')}_role'),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ],
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
      key: ValueKey('statusBadge_${user.id}'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
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

// import 'package:flutter/material.dart';
// import '../../domain/entities/reported_user_entity.dart';

// class ReportedUserCard extends StatelessWidget {
//   final ReportedUser user;
//   final VoidCallback? onIgnore;
//   final VoidCallback? onSuspend;

//   const ReportedUserCard({
//     super.key,
//     required this.user,
//     this.onIgnore,
//     this.onSuspend,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Top row
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildReporterBlock(
//                 "REPORTED USER",
//                 user.reportedUser,
//                 user.reportedUserRole,
//                 user.reportedUserAvatar,
//               ),
//               const SizedBox(height: 12),
//               _buildReporterBlock(
//                 "REPORTED BY",
//                 user.reportedBy,
//                 null,
//                 user.reporterAvatar,
//               ),
//             ],
//           ),

//           const SizedBox(height: 10),
//           Text("REASON", style: theme.textTheme.labelLarge),
//           const SizedBox(height: 4),
//           Text(
//             user.reason,
//             style: const TextStyle(fontWeight: FontWeight.w500),
//           ),
//           Text(
//             "Reported at ${_formatDateTime(user.reportedAt)}",
//             style: theme.textTheme.bodySmall,
//           ),
//           const SizedBox(height: 12),
//           LayoutBuilder(
//             builder: (context, constraints) {
//               final availableWidth = constraints.maxWidth;

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildStatusBadge(user.status),
//                   if (user.status == "Pending") ...[
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: availableWidth * 0.45,
//                           child: OutlinedButton(
//                             onPressed: onIgnore,
//                             child: const Text("Ignore"),
//                           ),
//                         ),
//                         const Spacer(),
//                         SizedBox(
//                           width: availableWidth * 0.45,
//                           child: ElevatedButton(
//                             onPressed: onSuspend,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                             ),
//                             child: const Text("Suspend User"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildReporterBlock(
//     String label,
//     String name,
//     String? role,
//     String? avatarUrl,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 4),
//         Row(
//           children: [
//             CircleAvatar(
//               backgroundImage:
//                   avatarUrl != null ? NetworkImage(avatarUrl) : null,
//               child: avatarUrl == null ? const Icon(Icons.person) : null,
//               radius: 18,
//             ),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 if (role != null)
//                   Text(
//                     role,
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusBadge(String status) {
//     Color color;
//     switch (status) {
//       case "Pending":
//         color = Colors.amber;
//         break;
//       case "Actioned":
//         color = Colors.green;
//         break;
//       case "Dismissed":
//         color = Colors.grey;
//         break;
//       default:
//         color = Colors.black;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: color,
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }

//   String _formatDateTime(DateTime dt) {
//     return "${dt.month}/${dt.day}/${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
//   }
// }
