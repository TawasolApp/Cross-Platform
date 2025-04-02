import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/create_job.dart';
import '../providers/company_provider.dart';
import 'package:provider/provider.dart';

class AddJobScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // Controllers for job details
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _experienceLevelController =
      TextEditingController();
  final TextEditingController _locationTypeController = TextEditingController();
  final TextEditingController _employmentTypeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    // For responsive padding
    final screenWidth = MediaQuery.of(context).size.width;
    final padding =
        screenWidth > 600 ? 32.0 : 16.0; // Adjust padding for larger screens

    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Job"),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: SingleChildScrollView(
        // Wrap the body in SingleChildScrollView
        padding: EdgeInsets.all(padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items left
            children: [
              _buildTextField(
                _positionController,
                "Job Position",
                isRequired: true,
              ),
              _buildTextField(_industryController, "Industry"),
              _buildTextField(
                _locationController,
                "Location",
                isRequired: true,
              ),
              _buildTextField(
                _descriptionController,
                "Job Description",
                maxLines: 3,
              ),
              _buildTextField(
                _salaryController,
                "Salary",
                keyboardType: TextInputType.number,
              ),
              _buildTextField(_experienceLevelController, "Experience Level"),

              // Location Type Dropdown (required)
              _buildDropdown(
                controller: _locationTypeController,
                label: "Location Type",
                items: ['On-Site', 'Remote', 'Hybrid'],
                isRequired: true,
              ),
              SizedBox(height: 10),

              // Employment Type Dropdown (required)
              _buildDropdown(
                controller: _employmentTypeController,
                label: "Employment Type",
                items: ['Full-time', 'Part-time', 'Contract'],
                isRequired: true,
              ),

              SizedBox(height: 20),
              // Submit Button
              Consumer<CompanyProvider>(
                builder: (context, companyProvider, child) {
                  return companyProvider.isLoadingJobs
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () => _submitJob(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Submit Job",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build text fields
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  // Helper to build dropdown fields with white background
  Widget _buildDropdown({
    required TextEditingController controller,
    required String label,
    required List<String> items,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor:
              Colors.white, // Set the dropdown button background color to white
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (value) {
          controller.text = value ?? '';
        },
        items:
            items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return "Please select $label";
          }
          return null;
        },
        dropdownColor:
            Colors.white, // Set the dropdown menu background color to white
      ),
    );
  }

  // Submit job
  Future<void> _submitJob(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final newJob = CreateJobEntity(
      position: _positionController.text.trim(),
      industry: _industryController.text.trim(),
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      salary: _salaryController.text.trim().isNotEmpty
          ? double.tryParse(_salaryController.text.trim()) ?? 0.0
          : 0.0,
      experienceLevel: _experienceLevelController.text.trim(),
      locationType: _locationTypeController.text.trim(),
      employmentType: _employmentTypeController.text.trim(),
    );

    try {
      final companyProvider = Provider.of<CompanyProvider>(
        context,
        listen: false,
      );
      await companyProvider.addJob(newJob);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Job added successfully!")));
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to add job. Try again.")));
    }
  }
}
