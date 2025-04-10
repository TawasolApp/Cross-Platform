import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart'
    as entity;

class SkillWidget extends StatelessWidget {
  final entity.Skill skill;

  const SkillWidget({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skill Name & Endorsements
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.skillName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                if (skill.position != null && skill.position!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      skill.position!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    // Profile pictures of endorsers
                    // if (skill.endorsements != null && skill.endorsements!.isNotEmpty)
                    //   ...skill.endorsements!.take(3).map((Endorsement endorser) {
                    //     return Padding(
                    //       padding: const EdgeInsets.only(right: 4.0),
                    //       child: CircleAvatar(
                    //         radius: 10,
                    //         backgroundColor: Colors.grey,
                    //         // backgroundImage: NetworkImage(endorser.userId.profilePictureUrl ?? ''),
                    //       ),
                    //     );
                    //   }).toList(),

                    // Placeholder for endorsements

                    // Endorsements count
                    Text(
                      '${skill.endorsements?.length ?? 0} endorsements',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
