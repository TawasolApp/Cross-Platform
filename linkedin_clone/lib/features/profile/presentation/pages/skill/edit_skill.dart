import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EditSkillPage extends StatefulWidget {
  final Skill skill;
  final int index;

  const EditSkillPage({super.key, required this.skill, required this.index});

  @override
  State<EditSkillPage> createState() => _EditSkillPageState();
}

class _EditSkillPageState extends State<EditSkillPage> {
  final _formKey = GlobalKey<FormState>();
  final _skillNameController = TextEditingController(); // Read-only
  final _positionController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _skillNameController.text = widget.skill.skillName;
    _positionController.text = widget.skill.position ?? '';
  }

  @override
  void dispose() {
    _skillNameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _saveSkill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      // Create updated skill with new position
      final updatedSkill = Skill(
        skillName: _skillNameController.text,
        position:
            _positionController.text.isEmpty ? null : _positionController.text,
        endorsements: widget.skill.endorsements,
      );

      // Update the skill position
      await provider.updateSkill(widget.index, updatedSkill);

      if (mounted) {
        Navigator.pop(context, true); // Return success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update skill position: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
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
        title: const Text("Edit Skill"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveSkill,
            child:
                _isSaving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    )
                    : const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                    child: const Icon(
                      Icons.code,
                      size: 40,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Skill Name (Read-only)
              Card(
                color: Colors.grey.shade100,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: TextFormField(
                    controller: _skillNameController,
                    readOnly: true,
                    enabled: false, // Makes it clearly non-editable
                    decoration: const InputDecoration(
                      labelText: "Skill Name (Not Editable)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                  ),
                ),
              ),

              // Position (Where Used) - Editable, but optional
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: TextFormField(
                    controller: _positionController,
                    decoration: const InputDecoration(
                      labelText: "Where did you use this skill? (Optional)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    // No validator since it's optional
                  ),
                ),
              ),

              // Endorsements count (read-only display)
              if (widget.skill.endorsements != null &&
                  widget.skill.endorsements!.isNotEmpty)
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.thumb_up, color: Colors.blueGrey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "${widget.skill.endorsements!.length} ${widget.skill.endorsements!.length == 1 ? 'endorsement' : 'endorsements'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveSkill,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child:
                      _isSaving
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            "Save Skill",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
