import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/experience.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
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

          // Experience List
          const Experience(
            companyLogoUrl: 'https://www.mes-demarches.info/wp-content/uploads/sites/7/2021/05/total-energies-logo-vertical-marge-1.png',
            title: 'Internship Trainee',
            company: 'TotalEnergies',
            roleType: 'Internship',
            startDate: 'Jul 2023',
            endDate: 'Aug 2023',
            location: 'Cairo, Egypt',
            workType: 'On-site',
          ),
          const Experience(
            companyLogoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a1/Siemens-logo.svg',
            title: 'Embedded Systems Intern',
            company: 'Siemens Digital Industries',
            roleType: 'Internship',
            startDate: 'Sep 2023',
            endDate: 'Dec 2023',
            location: 'Cairo, Egypt',
            workType: 'Hybrid',
          ),
        ],
      ),
    );
  }
}