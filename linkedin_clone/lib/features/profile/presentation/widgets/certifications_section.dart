import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/certification/add_certification.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/certification/certification_list.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/certification.dart';
import 'package:provider/provider.dart';

class CertificationsSection extends StatelessWidget {
  final List<Certification>? certifications;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final String? errorMessage;
  final bool isOwner;

  const CertificationsSection({
    super.key,
    this.certifications,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.errorMessage,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final certs = certifications ?? provider.certifications ?? [];
        final error = errorMessage ?? provider.certificationError;
        final visibleCertifications =
            isExpanded ? certs : certs.take(2).toList();

        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Licenses & Certifications',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isOwner)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const AddCertificationPage(),
                                ),
                              );

                              if (result == true) {
                                await provider.fetchProfile(provider.userId);
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const CertificationListPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Certifications List
              Column(
                children:
                    visibleCertifications
                        .map(
                          (cert) => CertificationWidget(
                            certification: cert,
                            showPresent: cert.expiryDate == null,
                          ),
                        )
                        .toList(),
              ),

              // "Show More / Show Less" Button
              if (certs.length > 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: onToggleExpansion,
                    child: Text(isExpanded ? 'Show less' : 'Show more'),
                  ),
                ),

              // Error Message
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),

              // Show empty state message when no certifications and user is owner
              if (certs.isEmpty && isOwner)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Add licenses and certifications to showcase your qualifications.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
