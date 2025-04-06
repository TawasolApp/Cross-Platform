import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/certification/add_certification.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/certification/certification_list.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class CertificationsSection extends StatelessWidget {
  final List<Certification>? certifications;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final String? errorMessage;

  const CertificationsSection({
    super.key,
    this.certifications,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final certs = certifications ?? provider.certifications ?? [];
        final error = errorMessage ?? provider.certificationError;
        final visibleCertifications = isExpanded ? certs : certs.take(2).toList();

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
                    Expanded(
                      child: const Text(
                        'Licenses & Certifications',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                          onPressed: () async {
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddCertificationPage(),
                              ),
                            );
                            
                            if (result == true) {
                              await provider.fetchProfile();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CertificationListPage(),
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
                children: visibleCertifications.map((cert) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Organization Logo (Optional)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                            image: cert.companyPic != null
                                ? DecorationImage(
                                    image: NetworkImage(cert.companyPic!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: cert.companyPic == null
                              ? const Icon(Icons.verified, size: 24, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),

                        // Certification Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Certification Name (Bold)
                              Text(
                                cert.name,
                                style: const TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Issuing Organization
                              Text(
                                cert.company,
                                style: const TextStyle(
                                  fontSize: 14, 
                                  color: Colors.black87,
                                ),
                              ),

                              // Issue and Expiration Dates
                              Text(
                                cert.expirationDate != null && cert.expirationDate!.isNotEmpty
                                    ? "Issued: ${cert.issueDate} • Expires: ${cert.expirationDate}"
                                    : "Issued: ${cert.issueDate} • No Expiration",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}