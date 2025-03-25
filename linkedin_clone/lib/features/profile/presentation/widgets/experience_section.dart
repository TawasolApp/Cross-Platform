import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/experience/experience_list.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/experience.dart';

class ExperienceSection extends StatelessWidget {
  final ProfileProvider provider;
  final List<Experience>? experiences;
  final bool isExpanded;
  final Function onToggleExpansion;
  final Function(Experience)? onRemove;
  final String? errorMessage;

  const ExperienceSection({
    super.key,
    required this.provider,
    this.experiences,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.onRemove,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final exps = experiences ?? provider.experiences ?? [];
    final error = errorMessage ?? provider.experienceError;
    final visibleExperiences = isExpanded ? exps : exps.take(2).toList();

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
                  'Experience',
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
                          MaterialPageRoute(
                            builder: (context) => AddExperiencePage(provider: provider),
                          ),
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
                            builder: (context) => ExperienceListPage(
                              experiences: exps,
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

          // Experience List
          Column(
            children: visibleExperiences.map((exp) => ExperienceWidget(
              experience: exp,
            )).toList(),
          ),

          // Show More/Show Less Button
          if (exps.length > 2)
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