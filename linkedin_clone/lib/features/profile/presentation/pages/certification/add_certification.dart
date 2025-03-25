import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class AddCertificationPage extends StatelessWidget {
  final ProfileProvider? provider;

  const AddCertificationPage({super.key, this.provider});

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
        appBar: AppBar(title: const Text("Add Certification")),
        body: const Center(
          child: Text("Error: Profile provider not available"),
        ),
      );
    }
    
    // Form state variables
    String name = "";
    String issuingOrganization = "";
    String? issuingOrganizationPic;
    String issueDate = "";
    String? expirationDate;
    bool doesNotExpire = false;

    void saveCertification() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        final newCertification = Certification(
          name: name,
          issuingOrganization: issuingOrganization,
          issuingOrganizationPic: issuingOrganizationPic,
          issueDate: issueDate,
          expirationDate: doesNotExpire ? null : expirationDate,
        );
        
        // Save the certification using the profile provider
        profileProvider.addCertification(newCertification);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Certification added successfully!")),
        );

        Navigator.pop(context); // Go back after saving
      }
    }

    Future<void> selectDate(BuildContext context, Function(String) onDateSelected) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        onDateSelected("${picked.year}-${picked.month.toString().padLeft(2, '0')}");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text("Add Certification"),
        actions: [
          TextButton(
            onPressed: saveCertification,
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
                // Certification Name
                TextFormField(
                  decoration: const InputDecoration(labelText: "Certification Name"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => name = value!,
                ),
                const SizedBox(height: 10),

                // Issuing Organization
                TextFormField(
                  decoration: const InputDecoration(labelText: "Issuing Organization"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  onSaved: (value) => issuingOrganization = value!,
                ),
                const SizedBox(height: 10),

                // Issue Date (With Date Picker)
                StatefulBuilder(
                  builder: (context, setState) => Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Issue Date (YYYY-MM)"),
                          validator: (value) => value == null || value.isEmpty ? "Required" : null,
                          controller: TextEditingController(text: issueDate),
                          readOnly: true,
                          onTap: () => selectDate(context, (date) => setState(() => issueDate = date)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Expiration Date and Checkbox for "Does Not Expire"
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: "Expiration Date (YYYY-MM)"),
                              controller: TextEditingController(text: expirationDate),
                              readOnly: true,
                              enabled: !doesNotExpire,
                              onTap: () => selectDate(context, (date) => setState(() => expirationDate = date)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: doesNotExpire,
                            onChanged: (value) {
                              setState(() {
                                doesNotExpire = value!;
                                if (value) expirationDate = null;
                              });
                            },
                          ),
                          const Text("This certification does not expire"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Issuing Organization Pic (Optional)
                TextFormField(
                  decoration: const InputDecoration(labelText: "Issuing Organization Picture URL (Optional)"),
                  onSaved: (value) => issuingOrganizationPic = value,
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveCertification,
                    child: const Text("Save Certification"),
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
