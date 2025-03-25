import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/education/add_education.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/education/education_list.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/education.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class EducationSection extends StatelessWidget {
  final List<Education>? educations;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final String? errorMessage;

  const EducationSection({
    super.key,
    this.educations,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
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
                          icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                          onPressed: () async {
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddEducationPage(),
                              ),
                            );
                            
                            if (result == true) {
                              await provider.fetchProfile();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EducationListPage(),
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

              // Show More/Show Less Button
              if (eduList.length > 2)
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
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}