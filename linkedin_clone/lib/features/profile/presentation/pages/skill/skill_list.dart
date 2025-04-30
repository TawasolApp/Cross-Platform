import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/skill/add_skill.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/skill/edit_skill.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class SkillListPage extends StatefulWidget {
  const SkillListPage({super.key});

  @override
  State<SkillListPage> createState() => _SkillListPageState();
}

class _SkillListPageState extends State<SkillListPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Skills",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: theme.primaryColor,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSkill(context),
        backgroundColor: theme.primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        if (provider.skills == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.skills!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "No skills added yet",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap the + button to add your skills",
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProfile(provider.userId),
          color: Theme.of(context).primaryColor,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Skills",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Showcase your professional skills and expertise",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // List of skills
              ...provider.skills!.asMap().entries.map(
                (entry) =>
                    _buildSkillCard(context, entry.value, entry.key, provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkillCard(
    BuildContext context,
    Skill skill,
    int index,
    ProfileProvider provider,
  ) {
    final endorsementCount = skill.endorsements?.length ?? 0;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _editSkill(context, skill, index),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skill icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.code,
                      color: theme.primaryColor,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Skill details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.skillName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Position (if available)
                      if (skill.position != null &&
                          skill.position!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                skill.position!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],

                      // Endorsements count
                      if (endorsementCount > 0) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$endorsementCount ${endorsementCount == 1 ? 'endorsement' : 'endorsements'}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text(
                          "No endorsements yet",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Actions
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == "edit") {
                      await _editSkill(context, skill, index);
                    } else if (value == "delete") {
                      await _deleteSkill(context, index, provider);
                    }
                  },
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 8),
                              const Text("Edit"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addSkill(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddSkillPage()),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshSkills(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Skill added successfully")),
        );
      }
    }
  }

  Future<void> _editSkill(BuildContext context, Skill skill, int index) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditSkillPage(skill: skill, index: index),
      ),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshSkills(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Skill position updated successfully")),
        );
      }
    }
  }

  Future<void> _deleteSkill(
    BuildContext context,
    int index,
    ProfileProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Skill"),
            content: const Text(
              "Are you sure you want to remove this skill? This action cannot be undone.",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text(
                  "Delete",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      setState(() => _isLoading = true);
      try {
        await provider.removeSkill(index);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Skill deleted successfully")),
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

  Future<void> _refreshSkills(ProfileProvider provider) async {
    setState(() => _isLoading = true);
    try {
      await provider.fetchProfile(provider.userId);
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
