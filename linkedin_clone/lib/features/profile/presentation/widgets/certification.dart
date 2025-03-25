import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class CertificationWidget extends StatelessWidget {
  final Certification certification;

  const CertificationWidget({
    super.key,
    required this.certification,
  });

  @override
  Widget build(BuildContext context) {
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
              color: Colors.grey[300], // Placeholder color
              borderRadius: BorderRadius.circular(4), // Square with slight rounding
              image: certification.issuingOrganizationPic != null
                  ? DecorationImage(
                      image: NetworkImage(certification.issuingOrganizationPic!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: certification.issuingOrganizationPic == null
                ? const Icon(Icons.verified, size: 24, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12), // Space between logo and text

          // Certification Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Certification Name (Bold)
                Text(
                  certification.name,
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Issuing Organization
                Text(
                  certification.issuingOrganization,
                  style: const TextStyle(
                    fontSize: 14, 
                    color: Colors.black87,
                  ),
                ),

                // Issue and Expiration Dates
                Text(
                  certification.expirationDate != null && certification.expirationDate!.isNotEmpty
                      ? "Issued: ${certification.issueDate} • Expires: ${certification.expirationDate}"
                      : "Issued: ${certification.issueDate} • No Expiration",
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
  }
}
