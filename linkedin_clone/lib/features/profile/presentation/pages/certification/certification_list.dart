import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/certification/add_certification.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/certification/edit_certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class CertificationListPage extends StatefulWidget {
  const CertificationListPage({super.key});

  @override
  State<CertificationListPage> createState() => _CertificationListPageState();
}

class _CertificationListPageState extends State<CertificationListPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Certifications"),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCertification(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        if (provider.certifications == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.certifications!.isEmpty) {
          return const Center(
            child: Text("No certifications added yet"),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProfile(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.certifications!.length,
            itemBuilder: (context, index) {
              final certification = provider.certifications![index];
              return _buildCertificationCard(context, certification, index, provider);
            },
          ),
        );
      },
    );
  }

  Widget _buildCertificationCard(
    BuildContext context,
    Certification certification,
    int index,
    ProfileProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editCertification(context, certification),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  certification.issuingOrganizationPic != null
                      ? CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(certification.issuingOrganizationPic!),
                        )
                      : const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.verified, size: 24),
                        ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certification.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          certification.issuingOrganization,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "edit") {
                        await _editCertification(context, certification);
                      } else if (value == "delete") {
                        await _deleteCertification(context, index, provider);
                      }
                    },
                    color: Colors.white,
                    elevation: 3,
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: "edit", child: Text("Edit")),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text("Delete", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                certification.expirationDate != null
                    ? "Issued: ${certification.issueDate} - Expires: ${certification.expirationDate}"
                    : "Issued: ${certification.issueDate} - No Expiration",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addCertification(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCertificationPage(),
      ),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshCertifications(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Certification added successfully")),
        );
      }
    }
  }

  Future<void> _editCertification(BuildContext context, Certification certification) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditCertificationPage(
          certification: certification,
        ),
      ),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshCertifications(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Certification updated successfully")),
        );
      }
    }
  }

  Future<void> _deleteCertification(
    BuildContext context,
    int index,
    ProfileProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Certification"),
        content: const Text("Are you sure you want to remove this certification?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      setState(() => _isLoading = true);
      try {
        await provider.removeCertification(index);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Certification deleted successfully")),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to delete: ${e.toString()}")),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _refreshCertifications(ProfileProvider provider) async {
    setState(() => _isLoading = true);
    try {
      await provider.fetchProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to refresh: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}