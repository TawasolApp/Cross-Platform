import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/certification.dart';

class CertificationsSection extends StatefulWidget {
  const CertificationsSection({super.key});

  @override
  _CertificationsSectionState createState() => _CertificationsSectionState();
}

class _CertificationsSectionState extends State<CertificationsSection> {
  bool showAll = false;

  // Example list of certifications (Replace with dynamic data)
  final List<Map<String, String>> certifications = [
    {
      'logoUrl': 'https://upload.wikimedia.org/wikipedia/commons/e/e0/LinkedIn_Logo.svg',
      'name': 'AWS Certified Solutions Architect',
      'issuingOrganization': 'Amazon Web Services (AWS)',
      'issueDate': 'Jan 2024',
      'expirationDate': 'Jan 2027',
      'credentialId': 'AWS-12345-XYZ',
    },
    {
      'logoUrl': 'https://upload.wikimedia.org/wikipedia/commons/8/80/Microsoft_logo.png',
      'name': 'Microsoft Certified: Azure Fundamentals',
      'issuingOrganization': 'Microsoft',
      'issueDate': 'Dec 2023',
      'expirationDate': '',
      'credentialId': 'AZ-900-45678',
    },
    {
      'logoUrl': 'https://upload.wikimedia.org/wikipedia/commons/3/3a/Google_Cloud_Logo.svg',
      'name': 'Google Associate Cloud Engineer',
      'issuingOrganization': 'Google Cloud',
      'issueDate': 'Feb 2024',
      'expirationDate': 'Feb 2027',
      'credentialId': 'GCP-ACE-78910',
    },
    {
      'logoUrl': 'https://upload.wikimedia.org/wikipedia/commons/4/4a/Cisco_logo.svg',
      'name': 'Cisco Certified Network Associate (CCNA)',
      'issuingOrganization': 'Cisco',
      'issueDate': 'Nov 2023',
      'expirationDate': 'Nov 2026',
      'credentialId': 'CCNA-56789',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Show only 2 items if `showAll` is false
    final visibleCertifications = showAll ? certifications : certifications.take(2).toList();

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
                  'Licenses & Certifications',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {}, // Add certification action
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {}, // Edit certifications action
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Display Certifications Dynamically
          Column(
            children: visibleCertifications.map((cert) {
              return Certification(
                logoUrl: cert['logoUrl']!,
                name: cert['name']!,
                issuingOrganization: cert['issuingOrganization']!,
                issueDate: cert['issueDate']!,
                expirationDate: cert['expirationDate']!,
                credentialId: cert['credentialId']!,
              );
            }).toList(),
          ),

          // "Show More / Show Less" Button
          if (certifications.length > 2)
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
