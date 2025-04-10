import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/experience/edit_experience.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ExperienceListPage extends StatefulWidget {
  const ExperienceListPage({super.key});

  @override
  State<ExperienceListPage> createState() => _ExperienceListPageState();
}

class _ExperienceListPageState extends State<ExperienceListPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Experience"),
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
        onPressed: () => _addExperience(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        if (provider.experiences == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.experiences!.isEmpty) {
          return const Center(child: Text("No experiences added yet"));
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProfile(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.experiences!.length,
            itemBuilder: (context, index) {
              final experience = provider.experiences![index];
              return _buildExperienceCard(context, experience, index, provider);
            },
          ),
        );
      },
    );
  }

  Widget _buildExperienceCard(
    BuildContext context,
    Experience experience,
    int index,
    ProfileProvider provider,
  ) {
    // Format the employment type for display
    String formatEmploymentType(String type) {
      // Convert snake_case to title case with hyphens
      return type
          .split('_')
          .map(
            (word) =>
                word.isNotEmpty
                    ? '${word[0].toUpperCase()}${word.substring(1)}'
                    : '',
          )
          .join('-');
    }

    // Format the location type for display
    String formatLocationType(String? type) {
      if (type == null) return '';
      // Convert snake_case to title case with hyphens
      return type
          .split('_')
          .map(
            (word) =>
                word.isNotEmpty
                    ? '${word[0].toUpperCase()}${word.substring(1)}'
                    : '',
          )
          .join('-');
    }

    final String formattedEmploymentType = formatEmploymentType(
      experience.employmentType,
    );
    final String formattedLocationType = formatLocationType(
      experience.locationType,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading:
            experience.companyLogo != null
                ? CircleAvatar(
                  backgroundImage: NetworkImage(experience.companyLogo!),
                )
                : const CircleAvatar(child: Icon(Icons.business)),
        title: Text(
          experience.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company with employment type
            Row(
              children: [
                Text(experience.company),
                const Text(" · ", style: TextStyle(color: Colors.grey)),
                Text(
                  formattedEmploymentType,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            // Location with location type if available
            if (experience.location != null && experience.location!.isNotEmpty)
              Row(
                children: [
                  Text(
                    experience.location!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  if (experience.locationType != null &&
                      experience.locationType!.isNotEmpty) ...[
                    const Text(
                      " · ",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      formattedLocationType,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ],
              ),
            // Date range
            Text(
              experience.endDate != null
                  ? "${experience.startDate} - ${experience.endDate}"
                  : "${experience.startDate} - Present",
              style: const TextStyle(color: Colors.grey),
            ),
            // Description
            if (experience.description != null &&
                experience.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  experience.description!,
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
              await _editExperience(context, experience);
            } else if (value == "delete") {
              await _deleteExperience(context, index, provider);
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
        onTap: () => _editExperience(context, experience),
      ),
    );
  }

  Future<void> _addExperience(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddExperiencePage()),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshExperiences(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Experience added successfully")),
        );
      }
    }
  }

  Future<void> _editExperience(
    BuildContext context,
    Experience experience,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditExperiencePage(experience: experience),
      ),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshExperiences(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Experience updated successfully")),
        );
      }
    }
  }

  Future<void> _deleteExperience(
    BuildContext context,
    int index,
    ProfileProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Experience"),
            content: const Text(
              "Are you sure you want to remove this experience?",
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
        await provider.removeExperience(index);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Experience deleted successfully")),
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

  Future<void> _refreshExperiences(ProfileProvider provider) async {
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
