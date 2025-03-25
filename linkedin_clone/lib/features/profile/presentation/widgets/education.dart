import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';

class EducationWidget extends StatelessWidget {
  final Education education;

  const EducationWidget({
    super.key,
    required this.education,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Square School Logo with Placeholder
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Placeholder color
                  borderRadius: BorderRadius.circular(4), // Square with slight rounding
                  image: education.schoolPic != null && education.schoolPic!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(education.schoolPic!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: education.schoolPic == null || education.schoolPic!.isEmpty
                    ? const Icon(Icons.school, size: 24, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12), // Space between logo and text

              // Education Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      education.school,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${education.degree} in ${education.field}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "${education.startDate} - ${education.endDate ?? 'Present'}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    if (education.grade.isNotEmpty)
                      Text(
                        "Grade: ${education.grade}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Description section if available
          if (education.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 52),
              child: Text(
                education.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}
