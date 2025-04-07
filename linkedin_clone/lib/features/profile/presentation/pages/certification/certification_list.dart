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
          return const Center(child: Text("No certifications added yet"));
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProfile(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.certifications!.length,
            itemBuilder: (context, index) {
              final certification = provider.certifications![index];
              return _buildCertificationCard(
                context,
                certification,
                index,
                provider,
              );
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading:
            certification.certificationPicture != null
                ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    certification.certificationPicture!,
                  ),
                  backgroundColor: Colors.grey[200],
                  onBackgroundImageError: (_, __) {
                    return;
                  },
                )
                : CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.verified, color: Colors.blue),
                ),
        title: Text(
          certification.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Issuing Organization
            Text(certification.company),
            const SizedBox(height: 2),

            // Date range - similar to education format
            Text(
              certification.expiryDate != null
                  ? "${certification.issueDate} - ${certification.expiryDate}"
                  : "${certification.issueDate} - Present",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == "edit") {
              await _editCertification(context, certification);
            } else if (value == "delete") {
              await _deleteCertification(context, index, provider);
            }
          },
          color: Colors.white,
          elevation: 3,
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: "edit", child: Text("Edit")),
                const PopupMenuItem(
                  value: "delete",
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
        ),
        onTap: () => _editCertification(context, certification),
      ),
    );
  }

  Future<void> _addCertification(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddCertificationPage()),
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

  Future<void> _editCertification(
    BuildContext context,
    Certification certification,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditCertificationPage(certification: certification),
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
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Certification"),
            content: const Text(
              "Are you sure you want to remove this certification?",
            ),
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
