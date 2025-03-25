import 'package:flutter/material.dart';
import 'add_experience.dart';
import 'edit_experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class ExperienceListPage extends StatefulWidget {
  final List<Experience> experiences;
  final ProfileProvider provider;

  const ExperienceListPage({
    super.key, 
    required this.experiences,
    required this.provider,
  });

  @override
  _ExperienceListPageState createState() => _ExperienceListPageState();
}

class _ExperienceListPageState extends State<ExperienceListPage> {
  late List<Experience> experiences;

  @override
  void initState() {
    super.initState();
    experiences = List.from(widget.experiences); // Copy list to modify locally
  }

  void _editExperience(int index) async {
    final updatedExperience = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExperiencePage(
          experience: experiences[index],
          provider: widget.provider,
        ),
      ),
    );

    if (updatedExperience != null) {
      setState(() {
        experiences[index] = updatedExperience;
      });
    }
  }

  void _deleteExperience(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Experience"),
        content: const Text("Are you sure you want to remove this experience?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.provider.removeExperience(index);
              setState(() {
                experiences.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addExperience() async {
    final newExperience = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExperiencePage(
          provider: widget.provider,
        ),
      ),
    );

    if (newExperience != null) {
      setState(() {
        experiences.add(newExperience);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Experience")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: experiences.length,
        itemBuilder: (context, index) {
          final experience = experiences[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: experience.companyPicUrl != null && experience.companyPicUrl!.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(experience.companyPicUrl!))
                  : const CircleAvatar(child: Icon(Icons.business)),
              title: Text(experience.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(experience.company),
                  Text(
                    experience.endDate != null
                        ? "${experience.startDate} - ${experience.endDate}"
                        : "${experience.startDate} - Present",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") _editExperience(index);
                  if (value == "delete") _deleteExperience(index);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: "edit", child: Text("Edit")),
                  const PopupMenuItem(value: "delete", child: Text("Delete")),
                ],
              ),
              onTap: () => _editExperience(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExperience,
        child: const Icon(Icons.add),
      ),
    );
  }
}
