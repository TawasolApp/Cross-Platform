import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class AddSkillPage extends StatelessWidget {
  final ProfileProvider? provider;

  const AddSkillPage({super.key, this.provider});

  @override
  Widget build(BuildContext context) {
    // Use formKey for validation
    final formKey = GlobalKey<FormState>();
    
    // Get provider - either passed directly or from context
    final profileProvider = provider ?? 
        ModalRoute.of(context)?.settings.arguments as ProfileProvider?;
    
    if (profileProvider == null) {
      // Handle error case if provider is not available
      return Scaffold(
        appBar: AppBar(title: const Text("Add Skill")),
        body: const Center(
          child: Text("Error: Profile provider not available"),
        ),
      );
    }
    
    // Form state variables
    String skill = "";

    void saveSkill() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        final newSkill = Skill(
          skill: skill,
          endorsements: [],
        );
        
        // Save the skill using the profile provider
        profileProvider.addSkill(newSkill);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Skill added successfully!")),
        );

        Navigator.pop(context); // Go back after saving
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Skill"),
        actions: [
          TextButton(
            onPressed: saveSkill,
            child: const Text("Save", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skill Name
              TextFormField(
                decoration: const InputDecoration(labelText: "Skill Name"),
                validator: (value) => value == null || value.isEmpty ? "Required" : null,
                onSaved: (value) => skill = value!,
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveSkill,
                  child: const Text("Save Skill"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
