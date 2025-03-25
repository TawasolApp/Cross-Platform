import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class AddEducationPage extends StatelessWidget {
  final ProfileProvider? provider;

  const AddEducationPage({super.key, this.provider});

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
        appBar: AppBar(title: const Text("Add Education")),
        body: const Center(
          child: Text("Error: Profile provider not available"),
        ),
      );
    }
    
    // Form state variables
    String school = "";
    String? schoolPic; // Nullable
    String degree = "Bachelor's"; // Default value
    String field = "";
    String startDate = "";
    String? endDate; // Nullable
    String grade = "";
    String description = "";
    bool isCurrentlyStudying = false;

    void saveEducation() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        // Creating an instance of Education
        final newEducation = Education(
          school: school,
          schoolPic: schoolPic,
          degree: degree,
          field: field,
          startDate: startDate,
          endDate: isCurrentlyStudying ? "Present" : endDate,
          grade: grade,
          description: description,
        );
        
        // Save the education using the profile provider
        profileProvider.addEducation(newEducation);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Education added successfully!")),
        );

        Navigator.pop(context); // Go back after saving
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Education"),
        actions: [
          TextButton(
            onPressed: saveEducation,
            child: const Text("Save", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // School Logo Picker
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Image selection logic would go here
                    },
                    child: StatefulBuilder(
                      builder: (context, setState) => CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: schoolPic != null
                            ? NetworkImage(schoolPic!)
                            : null,
                        child: schoolPic == null
                            ? const Icon(Icons.school, size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // School Name
                TextFormField(
                  decoration: const InputDecoration(labelText: "School/University"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => school = value!,
                ),
                const SizedBox(height: 10),

                // Degree Dropdown
                StatefulBuilder(
                  builder: (context, setState) => DropdownButtonFormField<String>(
                    value: degree,
                    items: [
                      "Bachelor's",
                      "Master's",
                      "PhD",
                      "Associate's",
                      "Diploma",
                      "Certification"
                    ].map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => degree = value!),
                    decoration: const InputDecoration(labelText: "Degree"),
                  ),
                ),
                const SizedBox(height: 10),

                // Field of Study
                TextFormField(
                  decoration: const InputDecoration(labelText: "Field of Study"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => field = value!,
                ),
                const SizedBox(height: 10),

                // Start Date
                TextFormField(
                  decoration: const InputDecoration(labelText: "Start Date (YYYY-MM)"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => startDate = value!,
                ),
                const SizedBox(height: 10),

                // End Date and Currently Studying checkbox
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: "End Date (YYYY-MM)"),
                        validator: (value) {
                          if (!isCurrentlyStudying && (value == null || value.isEmpty)) {
                            return "Required";
                          }
                          return null;
                        },
                        onSaved: (value) => endDate = value,
                        enabled: !isCurrentlyStudying,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: isCurrentlyStudying,
                            onChanged: (value) {
                              setState(() {
                                isCurrentlyStudying = value!;
                                if (value) endDate = "Present";
                              });
                            },
                          ),
                          const Text("I am currently studying here"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Grade
                TextFormField(
                  decoration: const InputDecoration(labelText: "Grade"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => grade = value!,
                ),
                const SizedBox(height: 10),

                // Description
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => description = value!,
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveEducation,
                    child: const Text("Save Education"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
