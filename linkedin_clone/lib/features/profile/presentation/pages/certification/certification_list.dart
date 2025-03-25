import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/certification/add_certification.dart';
import 'edit_certification.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class CertificationListPage extends StatefulWidget {
  final List<Certification> certifications;
  final ProfileProvider provider;

  const CertificationListPage({
    super.key, 
    required this.certifications,
    required this.provider,
  });

  @override
  _CertificationListPageState createState() => _CertificationListPageState();
}

class _CertificationListPageState extends State<CertificationListPage> {
  late List<Certification> certifications;

  @override
  void initState() {
    super.initState();
    certifications = List.from(widget.certifications); // Copy list to modify locally
  }

  void _editCertification(int index) async {
    final updatedCertification = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCertificationPage(
          certification: certifications[index],
          provider: widget.provider,
        ),
      ),
    );

    if (updatedCertification != null) {
      setState(() {
        certifications[index] = updatedCertification;
      });
    }
  }

  void _deleteCertification(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Certification"),
        content: const Text("Are you sure you want to remove this certification?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.provider.removeCertification(index);
              setState(() {
                certifications.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addCertification() async {
    final newCertification = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCertificationPage(
          provider: widget.provider,
        ),
      ),
    );

    if (newCertification != null) {
      setState(() {
        certifications.add(newCertification);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Certifications")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: certifications.length,
        itemBuilder: (context, index) {
          final certification = certifications[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: certification.issuingOrganizationPic != null && certification.issuingOrganizationPic!.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(certification.issuingOrganizationPic!))
                  : const CircleAvatar(child: Icon(Icons.verified)),
              title: Text(certification.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(certification.issuingOrganization),
                  Text(
                    certification.expirationDate != null
                        ? "Issued: ${certification.issueDate} - Expires: ${certification.expirationDate}"
                        : "Issued: ${certification.issueDate} - No Expiration",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") _editCertification(index);
                  if (value == "delete") _deleteCertification(index);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: "edit", child: Text("Edit")),
                  const PopupMenuItem(value: "delete", child: Text("Delete")),
                ],
              ),
              onTap: () => _editCertification(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCertification,
        child: const Icon(Icons.add),
      ),
    );
  }
}
