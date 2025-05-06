import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/experience/experience_list.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/experience.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class ExperienceSection extends StatelessWidget {
  final List<Experience>? experiences;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final String? errorMessage;
  final bool isOwner;

  const ExperienceSection({
    super.key,
    this.experiences,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.errorMessage,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
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
                                  builder:
                                      (context) => const AddExperiencePage(),
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
                                  builder:
                                      (context) => const ExperienceListPage(),
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
                children:
                    visibleExperiences
                        .map(
                          (exp) => ExperienceWidget(
                            experience: exp,
                            showPresent:
                                exp.endDate ==
                                null, // This part already handles showing "Present" correctly
                          ),
                        )
                        .toList(),
              ),

              // Show More/Show Less Button
              if (exps.length > 2)
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

              // Show empty state message when no experiences and user is owner
              if (exps.isEmpty && isOwner)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Add your work experience to showcase your professional journey.',
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
