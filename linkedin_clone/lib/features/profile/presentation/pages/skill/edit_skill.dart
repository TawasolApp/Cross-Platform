import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EditSkillPage extends StatefulWidget {
  final Skill? skill;

  const EditSkillPage({
    super.key, 
    this.skill,
  });

  @override
  State<EditSkillPage> createState() => _EditSkillPageState();
}

class _EditSkillPageState extends State<EditSkillPage> {
  final _formKey = GlobalKey<FormState>();
  final _skillController = TextEditingController();
  List<String>? _endorsements;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final skill = widget.skill;
    
    _skillController.text = skill?.skill ?? "";
    _endorsements = skill?.endorsements?.map((e) => e.userId).toList();
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _saveSkill() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      final skill = Skill(
        skill: _skillController.text,
        endorsements: _endorsements?.map((userId) => Endorsement(userId: userId)).toList(),
      );

      if (widget.skill != null) {
        await provider.updateSkill(widget.skill!, skill);
      } else {
        await provider.addSkill(skill);
      }
      
      if (mounted) {
        Navigator.pop(context, true); // Return success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save skill: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.skill != null ? "Edit Skill" : "Add Skill"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveSkill,
            child: _isSaving 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
                  )
                : const Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Skill Icon Placeholder
              Card(
                shape: const CircleBorder(),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.code, size: 40, color: Colors.blueGrey),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Skill Name
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _skillController,
                    decoration: const InputDecoration(
                      labelText: "Skill Name*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Endorsements count (read-only display)
              if (widget.skill != null && _endorsements != null)
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.thumb_up, color: Colors.blueGrey),
                        const SizedBox(width: 12),
                        Text(
                          "${_endorsements!.length} endorsements",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveSkill,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
                        )
                      : const Text(
                          "Save Skill", 
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}