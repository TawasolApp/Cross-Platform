import 'package:flutter/material.dart';
import 'education.dart'; // Import Education widget

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Matches Experience section background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Edit & Add Buttons
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
                      icon: const Icon(Icons.add),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {}, // Add education action
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {}, // Edit education action
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Education List
          const Education(
            institutionLogoUrl: 'https://upload.wikimedia.org/wikipedia/en/e/ed/Cairo_University_Crest.png',
            institution: 'Cairo University',
            degree: 'Bachelor of Science',
            field: 'Computer Engineering',
            startDate: '2019',
            endDate: '2023',
            grade: 'GPA: 3.8/4.0',
          ),

          const Education(
            institutionLogoUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a1/Siemens-logo.svg',
            institution: 'Siemens Digital Industries',
            degree: 'Embedded Systems Internship',
            field: 'Embedded Systems',
            startDate: 'Sep 2023',
            endDate: 'Dec 2023',
            grade: '',
          ),
        ],
      ),
    );
  }
}
