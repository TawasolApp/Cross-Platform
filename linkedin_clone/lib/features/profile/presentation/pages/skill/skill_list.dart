import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/skill/add_skill.dart';
import 'edit_skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class SkillListPage extends StatefulWidget {
  final List<Skill> skills;
  final ProfileProvider provider;

  const SkillListPage({
    super.key, 
    required this.skills,
    required this.provider,
  });

  @override
  _SkillListPageState createState() => _SkillListPageState();
}

class _SkillListPageState extends State<SkillListPage> {
  late List<Skill> skills;

  @override
  void initState() {
    super.initState();
    skills = List.from(widget.skills); // Copy list to modify locally
  }

  void _editSkill(int index) async {
    final updatedSkill = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSkillPage(
          skill: skills[index],
          provider: widget.provider,
        ),
      ),
    );

    if (updatedSkill != null && mounted) {
      setState(() {
        skills[index] = updatedSkill;
      });
    }
  }

  Future<void> _deleteSkill(int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Skill"),
        content: const Text("Are you sure you want to remove this skill?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      await widget.provider.removeSkill(index);
      setState(() {
        skills.removeAt(index);
      });
    }
  }

  void _addSkill() async {
    final newSkill = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSkillPage(
          provider: widget.provider,
        ),
      ),
    );

    if (newSkill != null && mounted) {
      setState(() {
        skills.add(newSkill);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Skills")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];
          final endorsementCount = skill.endorsements?.length ?? 0;

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.lightbulb)),
              title: Text(skill.skill, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: endorsementCount > 0 
                ? Text("$endorsementCount ${endorsementCount == 1 ? 'endorsement' : 'endorsements'}", 
                    style: const TextStyle(color: Colors.grey)) 
                : null,
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") _editSkill(index);
                  if (value == "delete") _deleteSkill(index);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: "edit", child: Text("Edit")),
                  const PopupMenuItem(
                    value: "delete",
                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              onTap: () => _editSkill(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSkill,
        child: const Icon(Icons.add),
      ),
    );
  }
}