import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/repost_bottom_sheet.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart'
    as entity;
import 'package:linkedin_clone/features/profile/presentation/pages/skill/endorsements_list.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class SkillWidget extends StatelessWidget {
  final entity.Skill skill;

  const SkillWidget({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    // Get the connection status from the profile provider to check if user is a connection
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isConnection = profileProvider.connectStatus == 'Connection';
    final ConnectionsProvider conncectionProvider =
        Provider.of<ConnectionsProvider>(context);

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
                const SizedBox(height: 8),
                // Endorsements count - make it clickable with button styling
                GestureDetector(
                  onTap: () {
                    // Navigate to endorsements list when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EndorsementsListPage(
                              skillName: skill.skillName,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      // Border removed
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.black),
                        const SizedBox(width: 6),
                        Text(
                          '${skill.endorsements?.length ?? 0} endorsements',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Add Endorse button only if user is a connection
          if (isConnection)
            TextButton.icon(
              onPressed: () async {
                bool result = await conncectionProvider.endorseSkill(
                  profileProvider.userId!,
                  skill.skillName,
                );
                if (result) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Endorsed ${skill.skillName}')),
                  );
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to endorse ${skill.skillName}'),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
              label: Text(
                'Endorse',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.05),
              ),
            ),
        ],
      ),
    );
  }
}
