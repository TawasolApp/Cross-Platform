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
          return const Center(
            child: Text("No education added yet"),
          );
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editEducation(context, education),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  education.schoolPic != null
                      ? CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(education.schoolPic!),
                        )
                      : const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.school, size: 24),
                        ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          education.school,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          education.degree,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "edit") {
                        await _editEducation(context, education);
                      } else if (value == "delete") {
                        await _deleteEducation(context, index, provider);
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
                education.field,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                education.endDate != null
                    ? "${education.startDate} - ${education.endDate}"
                    : "${education.startDate} - Present",
                style: const TextStyle(color: Colors.grey),
              ),
              if (education.grade.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  "Grade: ${education.grade}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
              if (education.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  education.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addEducation(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEducationPage(),
      ),
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
        builder: (context) => EditEducationPage(
          education: education,
        ),
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
      builder: (context) => AlertDialog(
        title: const Text("Delete Education"),
        content: const Text("Are you sure you want to remove this education?"),
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