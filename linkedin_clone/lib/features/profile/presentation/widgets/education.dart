import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';

class EducationWidget extends StatelessWidget {
  final Education education;
  final bool showPresent;

  const EducationWidget({
    super.key,
    required this.education,
    this.showPresent = false,
  });

  // Format degree type for display in a consistent way
  String _formatDegreeType(String type) {
    // Simply return the degree type (already in proper format)
    return type.trim();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDegree = _formatDegreeType(education.degree);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // School Logo
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:
                  education.schoolPic != null
                      ? Image.network(
                        education.schoolPic!,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 54,
                        height: 54,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.school, color: Colors.grey),
                      ),
            ),
          ),
          // Education Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  education.school,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                // Degree with field of study
                Row(
                  children: [
                    Text(formattedDegree, style: const TextStyle(fontSize: 14)),
                    const Text(
                      " · ",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      education.field,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Date range
                Text(
                  showPresent
                      ? "${education.startDate} - Present"
                      : "${education.startDate} - ${education.endDate}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                // Grade if available
                if (education.grade.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    "Grade: ${education.grade}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
                // Description
                if (education.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    education.description,
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
