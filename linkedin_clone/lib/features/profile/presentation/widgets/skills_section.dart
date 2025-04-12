import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/skill/add_skill.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/skill/skill_list.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/skill.dart'
    as skill_widget;
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class SkillsSection extends StatelessWidget {
  final List<Skill>? skills;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final String? errorMessage;
  final bool isOwner;

  const SkillsSection({
    super.key,
    this.skills,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.errorMessage,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final skillsList = skills ?? provider.skills ?? [];
        final error = errorMessage ?? provider.skillError;
        final visibleSkills =
            isExpanded ? skillsList : skillsList.take(3).toList();

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
                    const Expanded(
                      child: Text(
                        'Skills & Endorsements',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isOwner)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddSkillPage(),
                                ),
                              );

                              if (result == true) {
                                await provider.fetchProfile(provider.userId);
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SkillListPage(),
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
                children:
                    visibleSkills
                        .map((skill) => skill_widget.SkillWidget(skill: skill))
                        .toList(),
              ),

              // Show More/Show Less Button
              if (skillsList.length > 3)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: onToggleExpansion,
                    child: Text(isExpanded ? 'Show less' : 'Show more'),
                  ),
                ),

              // Error Message
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),

              // Show empty state message when no skills and user is owner
              if (skillsList.isEmpty && isOwner)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Add skills to showcase your expertise and get endorsements.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
