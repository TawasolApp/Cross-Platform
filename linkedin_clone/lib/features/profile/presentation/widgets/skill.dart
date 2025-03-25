import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart' as entity;
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';

class SkillWidget extends StatelessWidget {
  final entity.Skill skill;

  const SkillWidget({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skill Name & Endorsements
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                skill.skill,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  // Profile pictures of endorsers
                  if (skill.endorsements != null && skill.endorsements!.isNotEmpty)
                    ...skill.endorsements!.take(3).map((Endorsement endorser) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey,
                          // backgroundImage: NetworkImage(endorser.userId.profilePictureUrl ?? ''),
                        ),
                      );
                    }).toList(),

                  // Endorsements count
                  Text(
                    '${skill.endorsements?.length ?? 0}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
