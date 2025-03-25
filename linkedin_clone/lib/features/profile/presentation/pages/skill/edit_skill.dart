import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class EditSkillPage extends StatefulWidget {
  final Skill? skill;
  final ProfileProvider provider;

  const EditSkillPage({
    super.key, 
    this.skill,
    required this.provider,
  });

  @override
  _EditSkillPageState createState() => _EditSkillPageState();
}

class _EditSkillPageState extends State<EditSkillPage> {
  late TextEditingController skillController;
  List<String>? endorsements;

  @override
  void initState() {
    super.initState();

    final skill = widget.skill;
    
    skillController = TextEditingController(text: skill?.skill ?? "");
    endorsements = skill?.endorsements?.map((e) => e.userId).toList();
  }

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
  }

  Future<void> saveSkill() async {
    final updatedSkill = Skill(
      skill: skillController.text,
      endorsements: endorsements?.map((userId) => Endorsement(userId: userId)).toList(),
    );

    // Use provider to update skill
    if (widget.skill != null) {
      await widget.provider.updateSkill(widget.skill!, updatedSkill);
    } else {
      await widget.provider.addSkill(updatedSkill);
    }
    
    if (mounted) {
      Navigator.pop(context, updatedSkill);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Skill"),
        actions: [
          TextButton(
            onPressed: saveSkill,
            child: const Text("Save", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skill name field
              _buildTextField(skillController, "Skill Name"),
              
              // Endorsements count (read-only display)
              if (widget.skill != null && endorsements != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Endorsements: ${endorsements!.length}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // Save Button
              ElevatedButton(
                onPressed: saveSkill,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text("Save Skill", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}