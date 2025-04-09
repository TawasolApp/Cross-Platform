import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EditExperiencePage extends StatefulWidget {
  final Experience? experience;

  const EditExperiencePage({super.key, this.experience});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Define possible values for dropdowns
  static const List<String> employmentTypes = [
    "Full-time",
    "Part-time",
    "Internship",
    "Freelance",
  ];

  static const List<String> locationTypes = ["On-site", "Remote", "Hybrid"];

  String _employmentType = "Full-time";
  String _locationType = "On-site";
  bool _isCurrentlyWorking = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Initialize with existing experience if editing
    if (widget.experience != null) {
      final exp = widget.experience!;
      _titleController.text = exp.title;
      _companyController.text = exp.company;
      _locationController.text = exp.location ?? '';
      _startDateController.text = exp.startDate;
      _isCurrentlyWorking = exp.endDate == null;
      _endDateController.text =
          exp.endDate ?? (_isCurrentlyWorking ? 'Present' : '');
      _descriptionController.text = exp.description ?? '';

      // Convert stored values to match our dropdown options format
      final storedEmploymentType = exp.employmentType.replaceAll('_', '-');
      _employmentType = employmentTypes.firstWhere(
        (type) => type.toLowerCase() == storedEmploymentType.toLowerCase(),
        orElse: () => "Full-time",
      );

      if (exp.locationType != null) {
        final storedLocationType = exp.locationType!.replaceAll('_', '-');
        _locationType = locationTypes.firstWhere(
          (type) => type.toLowerCase() == storedLocationType.toLowerCase(),
          orElse: () => "On-site",
        );
      }

      _isCurrentlyWorking = exp.endDate == null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveExperience() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      // Make sure to set endDate to null when currently working
      String? endDate;
      if (!_isCurrentlyWorking) {
        endDate = _endDateController.text;
      }

      final experience = Experience(
        title: _titleController.text,
        company: _companyController.text,
        location:
            _locationController.text.isNotEmpty
                ? _locationController.text
                : null,
        startDate: _startDateController.text,
        endDate: endDate, // Use the correctly processed endDate
        description:
            _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
        employmentType: _employmentType.toLowerCase().replaceAll('-', '_'),
        locationType: _locationType.toLowerCase().replaceAll('-', '_'),
        workExperiencePicture: widget.experience?.workExperiencePicture,
      );

      if (widget.experience != null) {
        await provider.updateExperience(widget.experience!, experience);
      } else {
        await provider.addExperience(experience);
      }

      if (mounted) {
        Navigator.pop(context, true); // Return success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save experience: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: const DialogTheme(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.experience != null ? "Edit Experience" : "Add Experience",
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveExperience,
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
              // Company Logo Placeholder
              Card(
                shape: const CircleBorder(),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.business,
                      size: 40,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Job Title
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
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Job Title*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Company Name
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
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: "Company*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Location
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
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: "Location (Optional)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    // Validator removed as it's now optional
                  ),
                ),
              ),

              // Employment Type
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
                  child: DropdownButtonFormField<String>(
                    value: _employmentType,
                    items:
                        employmentTypes
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _employmentType = value);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Employment Type*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blueGrey,
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),

              // Location Type
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
                  child: DropdownButtonFormField<String>(
                    value: _locationType,
                    items:
                        locationTypes
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _locationType = value);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Location Type (Optional)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blueGrey,
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),

              // Start Date
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
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      labelText: "Start Date* (YYYY-MM)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, _startDateController),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // End Date and Currently Working
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText:
                          "End Date" +
                          (_isCurrentlyWorking ? " (Present)" : " (YYYY-MM)"),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      suffixIcon:
                          _isCurrentlyWorking
                              ? const Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              )
                              : null,
                    ),
                    readOnly: true,
                    enabled: !_isCurrentlyWorking,
                    onTap:
                        () =>
                            _isCurrentlyWorking
                                ? null
                                : _selectDate(context, _endDateController),
                    validator: (value) {
                      if (!_isCurrentlyWorking && (value?.isEmpty ?? true)) {
                        return "Required unless currently working";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Switch(
                        value: _isCurrentlyWorking,
                        onChanged: (value) {
                          setState(() {
                            _isCurrentlyWorking = value;
                            // Update end date field when switch changes
                            if (value) {
                              _endDateController.text = "Present";
                            } else {
                              _endDateController.clear();
                            }
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      const Text(
                        "I currently work here",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              // Description
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description (Optional)",
                      border: InputBorder.none,
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                    ),
                    maxLines: 5,
                    // Validator removed as it's now optional
                  ),
                ),
              ),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveExperience,
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
                            "Save Experience",
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
