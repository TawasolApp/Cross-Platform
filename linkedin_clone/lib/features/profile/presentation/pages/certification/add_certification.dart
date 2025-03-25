import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class AddCertificationPage extends StatefulWidget {
  const AddCertificationPage({super.key});

  @override
  State<AddCertificationPage> createState() => _AddCertificationPageState();
}

class _AddCertificationPageState extends State<AddCertificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuingOrgController = TextEditingController();
  final _issuingOrgPicController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expirationDateController = TextEditingController();
  
  bool _doesNotExpire = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _issuingOrgController.dispose();
    _issuingOrgPicController.dispose();
    _issueDateController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  Future<void> _saveCertification() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      final newCertification = Certification(
        name: _nameController.text,
        issuingOrganization: _issuingOrgController.text,
        issuingOrganizationPic: _issuingOrgPicController.text.isNotEmpty 
            ? _issuingOrgPicController.text 
            : null,
        issueDate: _issueDateController.text,
        expirationDate: _doesNotExpire ? null : _expirationDateController.text,
      );

      await provider.addCertification(newCertification);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Certification added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save certification: ${e.toString()}'),
            duration: Duration(seconds: 2),
          ),
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
        title: const Text("Add Certification"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveCertification,
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
              // Organization Logo Placeholder
              Card(
                shape: const CircleBorder(),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.verified, size: 40, color: Colors.blueGrey),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Certification Name
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Certification Name*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Issuing Organization
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _issuingOrgController,
                    decoration: const InputDecoration(
                      labelText: "Issuing Organization*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Issue Date
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _issueDateController,
                    decoration: const InputDecoration(
                      labelText: "Issue Date* (MM/YYYY)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, _issueDateController),
                    validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),

              // Expiration Date
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _expirationDateController,
                    decoration: const InputDecoration(
                      labelText: "Expiration Date (MM/YYYY)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    readOnly: true,
                    enabled: !_doesNotExpire,
                    onTap: () => _selectDate(context, _expirationDateController),
                    validator: (value) {
                      if (!_doesNotExpire && (value?.isEmpty ?? true)) {
                        return "Required unless certification doesn't expire";
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
                        value: _doesNotExpire,
                        onChanged: (value) {
                          setState(() {
                            _doesNotExpire = value;
                            if (value) {
                              _expirationDateController.clear();
                            }
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      const Text("Does not expire", style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),

              // Organization Picture URL
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextFormField(
                    controller: _issuingOrgPicController,
                    decoration: const InputDecoration(
                      labelText: "Organization Logo URL (Optional)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
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
                      : const Text(
                          "Save Certification",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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