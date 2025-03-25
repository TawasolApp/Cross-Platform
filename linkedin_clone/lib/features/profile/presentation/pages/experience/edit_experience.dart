import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class EditExperiencePage extends StatefulWidget {
  final Experience? experience;
  final ProfileProvider provider;

  const EditExperiencePage({
    super.key, 
    this.experience,
    required this.provider,
  });

  @override
  _EditExperiencePageState createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController titleController;
  late TextEditingController companyController;
  late TextEditingController locationController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController descriptionController;
  late TextEditingController employmentTypeController;
  late TextEditingController locationTypeController;
  late TextEditingController companyPicUrlController;

  bool isCurrentlyWorking = false;

  @override
  void initState() {
    super.initState();

    final exp = widget.experience;
    
    titleController = TextEditingController(text: exp?.title ?? "");
    companyController = TextEditingController(text: exp?.company ?? "");
    locationController = TextEditingController(text: exp?.location ?? "");
    startDateController = TextEditingController(text: exp?.startDate ?? "");
    endDateController = TextEditingController(text: exp?.endDate ?? "");
    descriptionController = TextEditingController(text: exp?.description ?? "");
    employmentTypeController = TextEditingController(text: exp?.employmentType ?? "");
    locationTypeController = TextEditingController(text: exp?.locationType ?? "");
    companyPicUrlController = TextEditingController(text: exp?.companyPicUrl ?? "");

    isCurrentlyWorking = exp?.endDate == null;
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    employmentTypeController.dispose();
    locationTypeController.dispose();
    companyPicUrlController.dispose();
    super.dispose();
  }

  void saveExperience() {
    final updatedExperience = Experience(
      title: titleController.text,
      company: companyController.text,
      location: locationController.text,
      startDate: startDateController.text,
      endDate: isCurrentlyWorking ? null : endDateController.text,
      description: descriptionController.text,
      employmentType: employmentTypeController.text,
      locationType: locationTypeController.text,
      companyPicUrl: companyPicUrlController.text.isNotEmpty ? companyPicUrlController.text : null,
    );

    // Use provider to update experience
    if (widget.experience != null) {
      widget.provider.updateExperience(widget.experience!, updatedExperience);
    } else {
      widget.provider.addExperience(updatedExperience);
    }
    
    Navigator.pop(context, updatedExperience);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Experience"),
        actions: [
          TextButton(
            onPressed: saveExperience,
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
              _buildTextField(titleController, "Job Title"),
              _buildTextField(companyController, "Company"),
              _buildTextField(locationController, "Location"),
              _buildTextField(startDateController, "Start Date"),
              
              // Toggle for "Currently Working Here"
              Row(
                children: [
                  Checkbox(
                    value: isCurrentlyWorking,
                    onChanged: (bool? value) {
                      setState(() {
                        isCurrentlyWorking = value ?? false;
                        if (isCurrentlyWorking) {
                          endDateController.clear();
                        }
                      });
                    },
                  ),
                  const Text("Currently Working Here"),
                ],
              ),

              if (!isCurrentlyWorking) _buildTextField(endDateController, "End Date"),
              
              _buildTextField(descriptionController, "Description", maxLines: 3),
              _buildTextField(employmentTypeController, "Employment Type"),
              _buildTextField(locationTypeController, "Location Type"),
              _buildTextField(companyPicUrlController, "Company Logo URL (Optional)"),

              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: saveExperience,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text("Save Experience", style: TextStyle(fontSize: 16)),
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
