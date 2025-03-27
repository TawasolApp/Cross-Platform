import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class ExperienceWidget extends StatelessWidget {
  final Experience experience;

  const ExperienceWidget({
    super.key,
    required this.experience,
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
              // Square Company Logo with Placeholder
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Placeholder color
                  borderRadius: BorderRadius.circular(4), // Square with slight rounding
                  image: experience.companyPicUrl != null && experience.companyPicUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(experience.companyPicUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: experience.companyPicUrl == null || experience.companyPicUrl!.isEmpty
                    ? const Icon(Icons.business, size: 24, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12), // Space between logo and text

              // Job Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${experience.company} • ${experience.employmentType}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "${experience.startDate} - ${experience.endDate ?? 'Present'} • ${experience.location}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      experience.locationType,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
