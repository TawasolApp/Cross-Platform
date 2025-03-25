import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class AddExperiencePage extends StatelessWidget {
  final ProfileProvider? provider;

  const AddExperiencePage({super.key, this.provider});

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
        appBar: AppBar(title: const Text("Add Experience")),
        body: const Center(
          child: Text("Error: Profile provider not available"),
        ),
      );
    }
    
    // Form state variables
    String title = "";
    String company = "";
    String location = "";
    String startDate = "";
    String? endDate;
    String description = "";
    String employmentType = "Full-time";
    String locationType = "On-site";
    String? companyPicUrl;
    bool isCurrentlyWorking = false;

    void saveExperience() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        // Create the experience
        final newExperience = Experience(
          title: title,
          company: company,
          location: location,
          startDate: startDate,
          endDate: isCurrentlyWorking ? "Present" : endDate,
          description: description,
          employmentType: employmentType,
          locationType: locationType,
          companyPicUrl: companyPicUrl,
        );
        
        // Save the experience using the profile provider
        profileProvider.addExperience(newExperience);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Experience added successfully!")),
        );

        Navigator.pop(context); // Go back after saving
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Experience"),
        actions: [
          TextButton(
            onPressed: saveExperience,
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
                // Company Logo Picker
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Image selection logic would go here
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: companyPicUrl != null
                          ? NetworkImage(companyPicUrl!)
                          : null,
                      child: companyPicUrl == null
                          ? const Icon(Icons.business, size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Job Title
                TextFormField(
                  decoration: const InputDecoration(labelText: "Job Title"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => title = value!,
                ),
                const SizedBox(height: 10),

                // Company Name
                TextFormField(
                  decoration: const InputDecoration(labelText: "Company"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => company = value!,
                ),
                const SizedBox(height: 10),

                // Location
                TextFormField(
                  decoration: const InputDecoration(labelText: "Location"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => location = value!,
                ),
                const SizedBox(height: 10),

                // Employment Type Dropdown
                StatefulBuilder(
                  builder: (context, setState) => DropdownButtonFormField<String>(
                    value: employmentType,
                    items: ["Full-time", "Part-time", "Internship", "Freelance"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => employmentType = value!);
                    },
                    decoration: const InputDecoration(labelText: "Employment Type"),
                  ),
                ),
                const SizedBox(height: 10),

                // Location Type Dropdown
                StatefulBuilder(
                  builder: (context, setState) => DropdownButtonFormField<String>(
                    value: locationType,
                    items: ["On-site", "Remote", "Hybrid"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => locationType = value!);
                    },
                    decoration: const InputDecoration(labelText: "Location Type"),
                  ),
                ),
                const SizedBox(height: 10),

                // Start Date
                TextFormField(
                  decoration: const InputDecoration(labelText: "Start Date (YYYY-MM)"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => startDate = value!,
                ),
                const SizedBox(height: 10),

                // End Date with Currently Working checkbox
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: "End Date (YYYY-MM)"),
                          validator: (value) {
                            if (!isCurrentlyWorking && (value == null || value.isEmpty)) {
                              return "Required";
                            }
                            return null;
                          },
                          onSaved: (value) => endDate = value,
                          enabled: !isCurrentlyWorking,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: isCurrentlyWorking,
                              onChanged: (value) {
                                setState(() {
                                  isCurrentlyWorking = value!;
                                  if (value) endDate = "Present";
                                });
                              },
                            ),
                            const Text("I am currently working here"),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Job Description
                TextFormField(
                  decoration: const InputDecoration(labelText: "Job Description"),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => description = value!,
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveExperience,
                    child: const Text("Save Experience"),
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
