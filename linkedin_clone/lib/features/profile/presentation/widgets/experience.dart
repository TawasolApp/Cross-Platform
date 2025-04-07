import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class ExperienceWidget extends StatelessWidget {
  final Experience experience;
  final bool showPresent;

  const ExperienceWidget({
    super.key,
    required this.experience,
    this.showPresent = false,
  });

  // Format the employment type for display
  String _formatEmploymentType(String type) {
    // Convert snake_case to title case with hyphens
    return type
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join('-');
  }

  // Format the location type for display
  String _formatLocationType(String? type) {
    if (type == null) return '';
    // Convert snake_case to title case with hyphens
    return type
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join('-');
  }

  @override
  Widget build(BuildContext context) {
    final String formattedEmploymentType = _formatEmploymentType(
      experience.employmentType,
    );
    final String formattedLocationType = _formatLocationType(
      experience.locationType,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Logo
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:
                  experience.workExperiencePicture != null
                      ? Image.network(
                        experience.workExperiencePicture!,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 54,
                        height: 54,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.business, color: Colors.grey),
                      ),
            ),
          ),
          // Experience Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                // Company name with employment type
                Row(
                  children: [
                    Text(
                      experience.company,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Text(
                      " · ",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      formattedEmploymentType,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Date range
                Text(
                  showPresent
                      ? "${experience.startDate} - Present"
                      : "${experience.startDate} - ${experience.endDate}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                // Location with location type if available
                if (experience.location != null &&
                    experience.location!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        experience.location!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      if (experience.locationType != null &&
                          experience.locationType!.isNotEmpty) ...[
                        const Text(
                          " · ",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          formattedLocationType,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                // Description
                if (experience.description != null &&
                    experience.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    experience.description!,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
