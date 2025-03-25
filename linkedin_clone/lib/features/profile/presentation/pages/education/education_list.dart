import 'package:flutter/material.dart';
import 'add_education.dart';
import 'edit_education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class EducationListPage extends StatefulWidget {
  final List<Education> educations;
  final ProfileProvider provider;

  const EducationListPage({
    super.key, 
    required this.educations,
    required this.provider,
  });

  @override
  _EducationListPageState createState() => _EducationListPageState();
}

class _EducationListPageState extends State<EducationListPage> {
  late List<Education> educations;

  @override
  void initState() {
    super.initState();
    educations = List.from(widget.educations); // Copy list to modify locally
  }

  void _editEducation(int index) async {
    final updatedEducation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEducationPage(
          education: educations[index],
          provider: widget.provider,
        ),
      ),
    );

    if (updatedEducation != null) {
      setState(() {
        educations[index] = updatedEducation;
      });
    }
  }

  void _deleteEducation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Education"),
        content: const Text("Are you sure you want to remove this education?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.provider.removeEducation(index);
              setState(() {
                educations.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addEducation() async {
    final newEducation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEducationPage(
          provider: widget.provider,
        ),
      ),
    );

    if (newEducation != null) {
      setState(() {
        educations.add(newEducation);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Education")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: educations.length,
        itemBuilder: (context, index) {
          final education = educations[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: education.schoolPic != null && education.schoolPic!.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(education.schoolPic!))
                  : const CircleAvatar(child: Icon(Icons.school)),
              title: Text(education.school, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(education.degree),
                  Text(
                    education.endDate != null 
                        ? "${education.startDate} - ${education.endDate}"
                        : "${education.startDate} - Present",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") _editEducation(index);
                  if (value == "delete") _deleteEducation(index);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: "edit", child: Text("Edit")),
                  const PopupMenuItem(value: "delete", child: Text("Delete")),
                ],
              ),
              onTap: () => _editEducation(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEducation,
        child: const Icon(Icons.add),
      ),
    );
  }
}
