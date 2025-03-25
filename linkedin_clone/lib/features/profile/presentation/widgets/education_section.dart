import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/education/add_education.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/education/education_list.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/education.dart';

class EducationSection extends StatelessWidget {
  final ProfileProvider provider;
  final List<Education>? educations;
  final bool isExpanded;
  final Function onToggleExpansion;
  final Function(Education)? onRemove;
  final String? errorMessage;

  const EducationSection({
    super.key,
    required this.provider,
    this.educations,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.onRemove,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final eduList = educations ?? provider.educations ?? [];
    final error = errorMessage ?? provider.educationError;
    final visibleEducations = isExpanded ? eduList : eduList.take(2).toList();

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
                  'Education',
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
                            builder: (context) => AddEducationPage(provider: provider),
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
                            builder: (context) => EducationListPage(
                              educations: eduList,
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

          // Education List
          Column(
            children: visibleEducations.map((education) => EducationWidget(
              education: education,
            )).toList(),
          ),

          // Show More/Less Button
          if (eduList.length > 2)
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