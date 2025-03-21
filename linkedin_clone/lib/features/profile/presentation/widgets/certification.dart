import 'package:flutter/material.dart';

class Certification extends StatelessWidget {
  final String logoUrl;
  final String name;
  final String issuingOrganization;
  final String issueDate;
  final String expirationDate;
  final String credentialId;

  const Certification({
    super.key,
    required this.logoUrl,
    required this.name,
    required this.issuingOrganization,
    required this.issueDate,
    required this.expirationDate,
    required this.credentialId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Organization Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder color
              borderRadius: BorderRadius.circular(4), // Square with slight rounding
              image: logoUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(logoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: logoUrl.isEmpty
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
                  name,
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Issuing Organization
                Text(
                  issuingOrganization,
                  style: const TextStyle(
                    fontSize: 14, 
                    color: Colors.black87,
                  ),
                ),

                // Issue and Expiration Dates
                Text(
                  expirationDate.isNotEmpty
                      ? "Issued: $issueDate • Expires: $expirationDate"
                      : "Issued: $issueDate • No Expiration",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                // Credential ID (Optional)
                if (credentialId.isNotEmpty)
                  Text(
                    "Credential ID: $credentialId",
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
