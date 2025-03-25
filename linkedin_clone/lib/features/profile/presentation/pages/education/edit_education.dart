import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class EditEducationPage extends StatefulWidget {
  final Education? education;
  final ProfileProvider provider;

  const EditEducationPage({
    super.key, 
    this.education,
    required this.provider,
  });

  @override
  _EditEducationPageState createState() => _EditEducationPageState();
}

class _EditEducationPageState extends State<EditEducationPage> {
  late TextEditingController schoolController;
  late TextEditingController degreeController;
  late TextEditingController fieldController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController descriptionController;
  late TextEditingController gradeController;
  late TextEditingController schoolPicController;

  bool isCurrentlyStudying = false;

  @override
  void initState() {
    super.initState();

    final edu = widget.education;
    
    schoolController = TextEditingController(text: edu?.school ?? "");
    degreeController = TextEditingController(text: edu?.degree ?? "");
    fieldController = TextEditingController(text: edu?.field ?? "");
    startDateController = TextEditingController(text: edu?.startDate ?? "");
    endDateController = TextEditingController(text: edu?.endDate ?? "");
    descriptionController = TextEditingController(text: edu?.description ?? "");
    gradeController = TextEditingController(text: edu?.grade ?? "");
    schoolPicController = TextEditingController(text: edu?.schoolPic ?? "");
    
    isCurrentlyStudying = edu?.endDate == null;
  }

  @override
  void dispose() {
    schoolController.dispose();
    degreeController.dispose();
    fieldController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    gradeController.dispose();
    schoolPicController.dispose();
    super.dispose();
  }

  void saveEducation() {
    final updatedEducation = Education(
      school: schoolController.text,
      degree: degreeController.text,
      field: fieldController.text,
      startDate: startDateController.text,
      endDate: isCurrentlyStudying ? null : endDateController.text,
      description: descriptionController.text,
      grade: gradeController.text,
      schoolPic: schoolPicController.text.isNotEmpty ? schoolPicController.text : null,
    );

    // Use provider to update education
    if (widget.education != null) {
      widget.provider.updateEducation(widget.education!, updatedEducation);
    } else {
      widget.provider.addEducation(updatedEducation);
    }
    
    Navigator.pop(context, updatedEducation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Education"),
        actions: [
          TextButton(
            onPressed: saveEducation,
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
              _buildTextField(schoolController, "School"),
              _buildTextField(degreeController, "Degree"),
              _buildTextField(fieldController, "Field of Study"),
              _buildTextField(startDateController, "Start Date"),
              
              // Toggle for "Currently Studying Here"
              Row(
                children: [
                  Checkbox(
                    value: isCurrentlyStudying,
                    onChanged: (bool? value) {
                      setState(() {
                        isCurrentlyStudying = value ?? false;
                        if (isCurrentlyStudying) {
                          endDateController.clear();
                        }
                      });
                    },
                  ),
                  const Text("Currently Studying Here"),
                ],
              ),
              
              if (!isCurrentlyStudying) _buildTextField(endDateController, "End Date"),
              _buildTextField(gradeController, "Grade"),
              _buildTextField(descriptionController, "Description", maxLines: 3),
              _buildTextField(schoolPicController, "School Logo URL (Optional)"),

              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: saveEducation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text("Save Education", style: TextStyle(fontSize: 16)),
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
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
