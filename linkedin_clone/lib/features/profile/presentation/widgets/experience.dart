import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class ExperienceWidget extends StatelessWidget {
  final Experience experience;

  const ExperienceWidget({super.key, required this.experience});

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
                  borderRadius: BorderRadius.circular(
                    4,
                  ), // Square with slight rounding
                  image:
                      experience.companyPicUrl != null &&
                              experience.companyPicUrl!.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(experience.companyPicUrl!),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    experience.companyPicUrl == null ||
                            experience.companyPicUrl!.isEmpty
                        ? const Icon(
                          Icons.business,
                          size: 24,
                          color: Colors.white,
                        )
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${experience.company} • ${experience.employmentType}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    // Date and location (if available)
                    Text(
                      _buildDateLocationText(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    // Location type (if available)
                    if (experience.locationType != null &&
                        experience.locationType!.isNotEmpty)
                      Text(
                        experience.locationType!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),

                    // Description (if available)
                    if (experience.description != null &&
                        experience.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          experience.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  // Helper method to build date and location text
  String _buildDateLocationText() {
    final dateText =
        "${experience.startDate} - ${experience.endDate ?? 'Present'}";

    if (experience.location != null && experience.location!.isNotEmpty) {
      return "$dateText • ${experience.location}";
    }

    return dateText;
  }
}
