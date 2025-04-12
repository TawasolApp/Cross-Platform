// import 'package:flutter/material.dart';
// import '../../domain/entities/post_entity.dart';
// //import 'reaction_icon.dart';
// import '../../../../core/utils/reaction_type.dart';

// class ReactionSummaryBar extends StatelessWidget {
//   final PostEntity post;

//   const ReactionSummaryBar({super.key, required this.post});

//   @override
//   Widget build(BuildContext context) {
//     int totalReactions =
//         post.reactCounts?.values.fold(0, (sum, count) => sum! + count) ?? 0;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Reactions and count display
//           if (totalReactions > 0)
//             Row(
//               children: [
//                 // Grouped Reaction Icons
//                 Row(
//                   children:
//                       post.reactCounts!.entries
//                           .where((entry) => entry.value > 0)
//                           .take(3) // Limit to 3 reactions for compact view
//                           .map(
//                             (entry) => Padding(
//                               padding: const EdgeInsets.only(right: 2),
//                               child: CircleAvatar(
//                                 radius: 9,
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   getReactionIcon(entry.key),
//                                   color: getReactionColor(entry.key),
//                                   size: 15,
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   "$totalReactions",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                 ),
//               ],
//             ),
//           // Comments and Shares aligned to the right
//           Row(
//             children: [
//               if (post.comments > 0) ...[
//                 Text(
//                   "${post.comments} comments",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//                 const SizedBox(width: 8),
//               ],
//               if (post.shares > 0)
//                 Text(
//                   "${post.shares} reposts",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import '../../../../core/utils/reaction_type.dart';

class ReactionSummaryBar extends StatelessWidget {
  final PostEntity post;

  const ReactionSummaryBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final reactCounts = post.reactCounts ?? {};
    final sortedReactions =
        reactCounts.entries.where((e) => e.value > 0).toList()
          ..sort((a, b) => b.value.compareTo(a.value)); // Sort by highest first

    final topReactions = sortedReactions.take(3).toList();
    final totalReactions = reactCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Reactions and count
          if (totalReactions > 0)
            Row(
              children: [
                // Top 3 reaction icons
                Row(
                  children:
                      topReactions
                          .map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: CircleAvatar(
                                radius: 9,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  getReactionIcon(entry.key),
                                  color: getReactionColor(entry.key),
                                  size: 15,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(width: 4),
                Text(
                  "$totalReactions",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),

          // Comments and Shares
          Row(
            children: [
              if (post.comments > 0) ...[
                Text(
                  "${post.comments} comments",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 8),
              ],
              if (post.shares > 0)
                Text(
                  "${post.shares} reposts",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
