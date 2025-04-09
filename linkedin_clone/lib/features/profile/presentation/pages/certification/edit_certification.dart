import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EditCertificationPage extends StatefulWidget {
  final Certification? certification;

  const EditCertificationPage({super.key, this.certification});

  @override
  State<EditCertificationPage> createState() => _EditCertificationPageState();
}

class _EditCertificationPageState extends State<EditCertificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuingOrgController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expiryDateController = TextEditingController();

  bool _isCurrentlyValid =
      false; // Renamed from _doesNotExpire to match education pattern
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Initialize with existing certification if editing
    if (widget.certification != null) {
      final cert = widget.certification!;
      _nameController.text = cert.name;
      _issuingOrgController.text = cert.company;
      _issueDateController.text = cert.issueDate;
      _isCurrentlyValid = cert.expiryDate == null;
      _expiryDateController.text =
          cert.expiryDate ?? (_isCurrentlyValid ? 'Present' : '');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuingOrgController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _saveCertification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      // Make sure to set expiryDate to null when certification doesn't expire
      String? expiryDate;
      if (!_isCurrentlyValid) {
        expiryDate = _expiryDateController.text;
      }

      final certification = Certification(
        name: _nameController.text,
        company: _issuingOrgController.text,
        certificationPicture: widget.certification?.certificationPicture,
        issueDate: _issueDateController.text,
        expiryDate: expiryDate, // Use the correctly processed expiryDate
      );

      if (widget.certification != null) {
        await provider.updateCertification(
          widget.certification!,
          certification,
        );
      } else {
        await provider.addCertification(certification);
      }

      if (mounted) {
        Navigator.pop(context, true); // Return success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save certification: ${e.toString()}'),
          ),
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
          widget.certification != null
              ? "Edit Certification"
              : "Add Certification",
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveCertification,
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
              // Organization Logo Placeholder
              Card(
                shape: const CircleBorder(),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.verified,
                      size: 40,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Certification Name
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
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Certification Name*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Issuing Organization
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
                    controller: _issuingOrgController,
                    decoration: const InputDecoration(
                      labelText: "Issuing Organization*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Issue Date
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
                    controller: _issueDateController,
                    decoration: const InputDecoration(
                      labelText: "Issue Date* (YYYY-MM)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, _issueDateController),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Expiry Date - Updated to match education end date pattern
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
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      labelText:
                          "Expiry Date" +
                          (_isCurrentlyValid ? " (Present)" : " (YYYY-MM)"),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      suffixIcon:
                          _isCurrentlyValid
                              ? const Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              )
                              : null,
                    ),
                    readOnly: true,
                    enabled: !_isCurrentlyValid,
                    onTap:
                        () =>
                            _isCurrentlyValid
                                ? null
                                : _selectDate(context, _expiryDateController),
                    validator: (value) {
                      if (!_isCurrentlyValid && (value?.isEmpty ?? true)) {
                        return "Required unless certificate does not expire";
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
                        value: _isCurrentlyValid,
                        onChanged: (value) {
                          setState(() {
                            _isCurrentlyValid = value;
                            // Update expiry date field when switch changes
                            if (value) {
                              _expiryDateController.text = "Present";
                            } else {
                              _expiryDateController.clear();
                            }
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      const Text(
                        "This certificate does not expire",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveCertification,
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
                            "Save Certification",
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
