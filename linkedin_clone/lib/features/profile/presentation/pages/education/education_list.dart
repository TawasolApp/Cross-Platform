import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/education/add_education.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/education/edit_education.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EducationListPage extends StatefulWidget {
  const EducationListPage({super.key});

  @override
  State<EducationListPage> createState() => _EducationListPageState();
}

class _EducationListPageState extends State<EducationListPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Education"),
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
        onPressed: () => _addEducation(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        if (provider.educations == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.educations!.isEmpty) {
          return const Center(child: Text("No education added yet"));
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProfile(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.educations!.length,
            itemBuilder: (context, index) {
              final education = provider.educations![index];
              return _buildEducationCard(context, education, index, provider);
            },
          ),
        );
      },
    );
  }

  Widget _buildEducationCard(
    BuildContext context,
    Education education,
    int index,
    ProfileProvider provider,
  ) {
    // Format degree type for display
    String formatDegreeType(String type) {
      // Convert to title case with proper formatting
      return type.trim();
    }

    final String formattedDegree = formatDegreeType(education.degree);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading:
            education.schoolPic != null
                ? CircleAvatar(
                  backgroundImage: NetworkImage(education.schoolPic!),
                )
                : const CircleAvatar(child: Icon(Icons.school)),
        title: Text(
          education.school,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Degree with field
            Row(
              children: [
                Text(formattedDegree),
                const Text(" · ", style: TextStyle(color: Colors.grey)),
                Text(
                  education.field,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            // Date range
            Text(
              education.endDate != null
                  ? "${education.startDate} - ${education.endDate}"
                  : "${education.startDate} - Present",
              style: const TextStyle(color: Colors.grey),
            ),
            // Grade
            if (education.grade.isNotEmpty)
              Text(
                "Grade: ${education.grade}",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            // Description
            if (education.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  education.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == "edit") {
              await _editEducation(context, education);
            } else if (value == "delete") {
              await _deleteEducation(context, index, provider);
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
        onTap: () => _editEducation(context, education),
      ),
    );
  }

  Future<void> _addEducation(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddEducationPage()),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshEducations(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Education added successfully")),
        );
      }
    }
  }

  Future<void> _editEducation(BuildContext context, Education education) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEducationPage(education: education),
      ),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshEducations(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Education updated successfully")),
        );
      }
    }
  }

  Future<void> _deleteEducation(
    BuildContext context,
    int index,
    ProfileProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Education"),
            content: const Text(
              "Are you sure you want to remove this education?",
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
        await provider.removeEducation(index);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Education deleted successfully")),
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

  Future<void> _refreshEducations(ProfileProvider provider) async {
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
