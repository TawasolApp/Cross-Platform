import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/certification.dart';

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key});

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

          // Certification List (Replace with dynamic data)
          const Certification(
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e0/LinkedIn_Logo.svg',
            name: 'AWS Certified Solutions Architect',
            issuingOrganization: 'Amazon Web Services (AWS)',
            issueDate: 'Jan 2024',
            expirationDate: 'Jan 2027',
            credentialId: 'AWS-12345-XYZ',
          ),
          const Certification(
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/80/Microsoft_logo.png',
            name: 'Microsoft Certified: Azure Fundamentals',
            issuingOrganization: 'Microsoft',
            issueDate: 'Dec 2023',
            expirationDate: '',
            credentialId: 'AZ-900-45678',
          ),
        ],
      ),
    );
  }
}
