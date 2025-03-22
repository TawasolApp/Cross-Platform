import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/experience.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  _ExperienceSectionState createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool showAll = false;

  // Example list of experiences (Replace with dynamic data)
  final List<Map<String, String>> experienceList = [
    {
      'companyLogoUrl': 'https://www.mes-demarches.info/wp-content/uploads/sites/7/2021/05/total-energies-logo-vertical-marge-1.png',
      'title': 'Internship Trainee',
      'company': 'TotalEnergies',
      'roleType': 'Internship',
      'startDate': 'Jul 2023',
      'endDate': 'Aug 2023',
      'location': 'Cairo, Egypt',
      'workType': 'On-site',
    },
    {
      'companyLogoUrl': 'https://upload.wikimedia.org/wikipedia/commons/a/a1/Siemens-logo.svg',
      'title': 'Embedded Systems Intern',
      'company': 'Siemens Digital Industries',
      'roleType': 'Internship',
      'startDate': 'Sep 2023',
      'endDate': 'Dec 2023',
      'location': 'Cairo, Egypt',
      'workType': 'Hybrid',
    },
    {
      'companyLogoUrl': 'https://upload.wikimedia.org/wikipedia/commons/5/57/Google_2015_logo.svg',
      'title': 'Software Engineering Intern',
      'company': 'Google',
      'roleType': 'Internship',
      'startDate': 'Jan 2024',
      'endDate': 'Present',
      'location': 'Remote',
      'workType': 'Remote',
    },
    {
      'companyLogoUrl': 'https://upload.wikimedia.org/wikipedia/commons/4/44/Microsoft_logo.svg',
      'title': 'Cloud Engineer Intern',
      'company': 'Microsoft',
      'roleType': 'Internship',
      'startDate': 'Mar 2024',
      'endDate': 'Present',
      'location': 'Remote',
      'workType': 'Hybrid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Show only 2 experiences if `showAll` is false
    final visibleExperiences = showAll ? experienceList : experienceList.take(2).toList();

    return Container(
      color: Colors.white, // Set background color to white
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {}, // Add experience action
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {}, // Edit experience action
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Display Experience Entries Dynamically
          Column(
            children: visibleExperiences.map((exp) {
              return Experience(
                companyLogoUrl: exp['companyLogoUrl']!,
                title: exp['title']!,
                company: exp['company']!,
                roleType: exp['roleType']!,
                startDate: exp['startDate']!,
                endDate: exp['endDate']!,
                location: exp['location']!,
                workType: exp['workType']!,
              );
            }).toList(),
          ),

          // "Show More / Show Less" Button
          if (experienceList.length > 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                child: Text(showAll ? 'Show less' : 'Show more'),
              ),
            ),
        ],
      ),
    );
  }
}
