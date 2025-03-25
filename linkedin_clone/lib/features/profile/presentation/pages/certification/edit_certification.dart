import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class EditCertificationPage extends StatefulWidget {
  final Certification? certification;
  final ProfileProvider provider;

  const EditCertificationPage({
    super.key, 
    this.certification,
    required this.provider,
  });

  @override
  _EditCertificationPageState createState() => _EditCertificationPageState();
}

class _EditCertificationPageState extends State<EditCertificationPage> {
  late TextEditingController nameController;
  late TextEditingController issuingOrganizationController;
  late TextEditingController issuingOrganizationPicController;
  late TextEditingController issueDateController;
  late TextEditingController expirationDateController;
  
  bool doesNotExpire = false;

  @override
  void initState() {
    super.initState();

    final cert = widget.certification;
    
    nameController = TextEditingController(text: cert?.name ?? "");
    issuingOrganizationController = TextEditingController(text: cert?.issuingOrganization ?? "");
    issuingOrganizationPicController = TextEditingController(text: cert?.issuingOrganizationPic ?? "");
    issueDateController = TextEditingController(text: cert?.issueDate ?? "");
    expirationDateController = TextEditingController(text: cert?.expirationDate ?? "");
    
    doesNotExpire = cert?.expirationDate == null;
  }

  @override
  void dispose() {
    nameController.dispose();
    issuingOrganizationController.dispose();
    issuingOrganizationPicController.dispose();
    issueDateController.dispose();
    expirationDateController.dispose();
    super.dispose();
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}";
      });
    }
  }

  void saveCertification() {
    final updatedCertification = Certification(
      name: nameController.text,
      issuingOrganization: issuingOrganizationController.text,
      issuingOrganizationPic: issuingOrganizationPicController.text.isNotEmpty 
          ? issuingOrganizationPicController.text 
          : null,
      issueDate: issueDateController.text,
      expirationDate: doesNotExpire ? null : expirationDateController.text,
    );

    // Use provider to update certification
    if (widget.certification != null) {
      widget.provider.updateCertification(widget.certification!, updatedCertification);
    } else {
      widget.provider.addCertification(updatedCertification);
    }
    
    Navigator.pop(context, updatedCertification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Certification"),
        actions: [
          TextButton(
            onPressed: saveCertification,
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
              _buildTextField(nameController, "Certification Name"),
              _buildTextField(issuingOrganizationController, "Issuing Organization"),
              
              // Issue Date field with date picker
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: issueDateController,
                  readOnly: true,
                  onTap: () => selectDate(context, issueDateController),
                  decoration: const InputDecoration(
                    labelText: "Issue Date (YYYY-MM)",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              
              // "Does Not Expire" checkbox
              Row(
                children: [
                  Checkbox(
                    value: doesNotExpire,
                    onChanged: (bool? value) {
                      setState(() {
                        doesNotExpire = value ?? false;
                        if (doesNotExpire) {
                          expirationDateController.clear();
                        }
                      });
                    },
                  ),
                  const Text("This certification does not expire"),
                ],
              ),
              
              // Expiration Date field with date picker (only if not "Does Not Expire")
              if (!doesNotExpire)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: expirationDateController,
                    readOnly: true,
                    onTap: () => selectDate(context, expirationDateController),
                    decoration: const InputDecoration(
                      labelText: "Expiration Date (YYYY-MM)",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              
              _buildTextField(
                issuingOrganizationPicController, 
                "Issuing Organization Logo URL (Optional)"
              ),

              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: saveCertification,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text("Save Certification", style: TextStyle(fontSize: 16)),
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
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
