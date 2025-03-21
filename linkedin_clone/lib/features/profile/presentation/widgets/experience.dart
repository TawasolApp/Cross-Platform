import 'package:flutter/material.dart';

class Experience extends StatelessWidget {
  final String companyLogoUrl;
  final String title;
  final String company;
  final String roleType; // E.g., Internship, Full-time
  final String startDate;
  final String endDate;
  final String location;
  final String workType; // E.g., On-site, Remote

  const Experience({
    super.key,
    required this.companyLogoUrl,
    required this.title,
    required this.company,
    required this.roleType,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.workType,
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
                  image: companyLogoUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(companyLogoUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: companyLogoUrl.isEmpty
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
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$company • $roleType",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "$startDate - $endDate • $location",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      workType,
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
