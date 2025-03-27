import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EditEducationPage extends StatefulWidget {
  final Education? education;

  const EditEducationPage({
    super.key,
    this.education,
  });

  @override
  State<EditEducationPage> createState() => _EditEducationPageState();
}

class _EditEducationPageState extends State<EditEducationPage> {
  final _formKey = GlobalKey<FormState>();
  final _schoolController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _gradeController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Define possible values for dropdowns
  static const List<String> degreeTypes = [
    "High School",
    "Bachelor's Degree",
    "Master's Degree",
    "Doctorate",
    "Associate Degree",
    "Professional Certificate"
  ];

  String _degreeType = "Bachelor's Degree";
  bool _isCurrentlyStudying = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Initialize with existing education if editing
    if (widget.education != null) {
      final edu = widget.education!;
      _schoolController.text = edu.school;
      _degreeController.text = edu.degree;
      _fieldController.text = edu.field;
      _startDateController.text = edu.startDate;
      _endDateController.text = edu.endDate ?? '';
      _gradeController.text = edu.grade;
      _descriptionController.text = edu.description;

      // Ensure the values exist in our dropdown options
      _degreeType = degreeTypes.contains(edu.degree)
          ? edu.degree
          : "Bachelor's Degree";

      _isCurrentlyStudying = edu.endDate == null;
    }
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _gradeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveEducation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      final education = Education(
        school: _schoolController.text,
        degree: _degreeController.text,
        field: _fieldController.text,
        startDate: _startDateController.text,
        endDate: _isCurrentlyStudying ? null : _endDateController.text,
        grade: _gradeController.text,
        description: _descriptionController.text,
      );

      if (widget.education != null) {
        await provider.updateEducation(widget.education!, education);
      } else {
        await provider.addEducation(education);
      }

      if (mounted) {
        Navigator.pop(context, true); // Return success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save education: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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
            dialogTheme: const DialogTheme(
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.education != null ? "Edit Education" : "Add Education"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveEducation,
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
              // School Logo Placeholder
              Card(
                shape: const CircleBorder(),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.school, size: 40, color: Colors.blueGrey),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // School Name
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _schoolController,
                    decoration: const InputDecoration(
                      labelText: "School*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Degree Type
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: DropdownButtonFormField<String>(
                    value: _degreeType,
                    items: degreeTypes
                        .map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _degreeType = value;
                          _degreeController.text = value;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Degree Type*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),

              // Field of Study
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _fieldController,
                    decoration: const InputDecoration(
                      labelText: "Field of Study*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Start Date
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      labelText: "Start Date* (MM/YYYY)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, _startDateController),
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // End Date and Currently Studying
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      labelText: "End Date (MM/YYYY)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    readOnly: true,
                    enabled: !_isCurrentlyStudying,
                    onTap: () => _isCurrentlyStudying ? null : _selectDate(context, _endDateController),
                    validator: (value) {
                      if (!_isCurrentlyStudying && (value?.isEmpty ?? true)) {
                        return "Required unless currently studying";
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Switch(
                        value: _isCurrentlyStudying,
                        onChanged: (value) {
                          setState(() => _isCurrentlyStudying = value);
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      const Text("I currently study here", style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),

              // Grade
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _gradeController,
                    decoration: const InputDecoration(
                      labelText: "Grade*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Description
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description*",
                      border: InputBorder.none,
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    ),
                    maxLines: 5,
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveEducation,
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
                      : Text(
                          widget.education != null ? "Update Education" : "Add Education",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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