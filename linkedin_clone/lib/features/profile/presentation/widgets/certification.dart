import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class CertificationWidget extends StatelessWidget {
  final Certification certification;
  final bool showPresent;

  const CertificationWidget({
    super.key,
    required this.certification,
    this.showPresent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Organization Logo
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:
                  certification.certificationPicture != null
                      ? Image.network(
                        certification.certificationPicture!,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: 54,
                              height: 54,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.verified,
                                color: Colors.blue,
                              ),
                            ),
                      )
                      : Container(
                        width: 54,
                        height: 54,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.verified, color: Colors.blue),
                      ),
            ),
          ),
          // Certification Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certification.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                // Issuing Organization
                Row(
                  children: [
                    Text(
                      certification.company,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Date range - similar to education format
                Text(
                  showPresent || certification.expiryDate == null
                      ? "${certification.issueDate} - Present"
                      : "${certification.issueDate} - ${certification.expiryDate}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
