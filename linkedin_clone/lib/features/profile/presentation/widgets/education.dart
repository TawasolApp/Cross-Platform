import 'package:flutter/material.dart';

class Education extends StatelessWidget {
  final String institutionLogoUrl;
  final String degree;
  final String field;
  final String institution;
  final String startDate;
  final String endDate;
  final String grade;

  const Education({
    super.key,
    required this.institutionLogoUrl,
    required this.degree,
    required this.field,
    required this.institution,
    required this.startDate,
    required this.endDate,
    required this.grade,
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
              // Square Institution Logo with Placeholder
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Placeholder color
                  borderRadius: BorderRadius.circular(4), // Slight rounding
                  image: institutionLogoUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(institutionLogoUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: institutionLogoUrl.isEmpty
                    ? const Icon(Icons.school, size: 24, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12), // Space between logo and text

              // Education Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Institution Name (Bold)
                    Text(
                      institution,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    // Degree & Field of Study
                    Text(
                      "$degree, $field",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),

                    // Start and End Dates
                    Text(
                      "$startDate - $endDate",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),

                    // Grade (Only if available)
                    if (grade.isNotEmpty)
                      Text(
                        "Grade: $grade",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
}
