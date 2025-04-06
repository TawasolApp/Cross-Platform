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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skills"),
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
        onPressed: () => _addSkill(context),
        child: const Icon(Icons.add),
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
          return const Center(
            child: Text("No skills added yet"),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProfile(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.skills!.length,
            itemBuilder: (context, index) {
              final skill = provider.skills![index];
              return _buildSkillCard(context, skill, index, provider);
            },
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
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const CircleAvatar(child: Icon(Icons.code)),
        title: Text(
          skill.skillName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: endorsementCount > 0
            ? Text(
                "$endorsementCount ${endorsementCount == 1 ? 'endorsement' : 'endorsements'}",
                style: const TextStyle(color: Colors.grey),
              )
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == "edit") {
              // await _editSkill(context, skill);
            } else if (value == "delete") {
              await _deleteSkill(context, index, provider);
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
        // onTap: () => _editSkill(context, skill),
      ),
    );
  }

  Future<void> _addSkill(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSkillPage(),
      ),
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

  // Future<void> _editSkill(BuildContext context, Skill skill) async {
  //   final result = await Navigator.push<bool>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => EditSkillPage(
  //         skill: skill,
  //       ),
  //     ),
  //   );

  //   if (result == true && mounted) {
  //     final provider = Provider.of<ProfileProvider>(context, listen: false);
  //     await _refreshSkills(provider);
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Skill updated successfully")),
  //       );
  //     }
  //   }
  // }

  Future<void> _deleteSkill(
    BuildContext context,
    int index,
    ProfileProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Skill"),
        content: const Text("Are you sure you want to remove this skill?"),
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