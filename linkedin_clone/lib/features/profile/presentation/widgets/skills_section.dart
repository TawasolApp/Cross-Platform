import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/skill.dart' as skill_widget;
import 'package:linkedin_clone/features/profile/presentation/pages/skill/add_skill.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/skill/skill_list.dart';

class SkillsSection extends StatelessWidget {
  final ProfileProvider provider;
  final List<Skill>? skills;
  final bool isExpanded;
  final Function onToggleExpansion;
  final Function(Skill)? onRemove;
  final String? errorMessage;

  const SkillsSection({
    super.key,
    required this.provider,
    this.skills,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.onRemove,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final skillsList = skills ?? provider.skills ?? [];
    final error = errorMessage ?? provider.skillError;
    final visibleSkills = isExpanded ? skillsList : skillsList.take(3).toList();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Skills & Endorsements',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddSkillPage(provider: provider)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SkillListPage(
                              skills: skillsList,
                              provider: provider,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Skills List
          Column(
            children: visibleSkills
                .map((skill) => skill_widget.SkillWidget(skill: skill))
                .toList(),
          ),

          // Show More/Show Less Button
          if (skillsList.length > 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () => onToggleExpansion(),
                child: Text(isExpanded ? 'Show less' : 'Show more'),
              ),
            ),

          // Error Message
          if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}