import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:linkedin_clone/features/company/presentation/providers/company_edit_provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_add_admins_screen.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class EditCompanyScreen extends StatelessWidget {
  final String companyId;
  final UpdateCompanyEntity company;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> companySizeOptions = [
    '1-50 Employees',
    '51-400 Employees',
    '401-1000 Employees',
    '1001-10000 Employees',
    '10000+ Employees',
  ];
  final List<String> companyTypeOptions = [
    "Public Company",
    "Self Employed",
    "Government Agency",
    "Non Profit",
    "Sole Proprietorship",
    "Privately Held",
    "Partnership",
  ];
  EditCompanyScreen({required this.companyId, required this.company});

  @override
  Widget build(BuildContext context) {
    final TextEditingController addAdminController = TextEditingController();
    final TextEditingController nameController = TextEditingController(
      text: company.name,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: company.description,
    );
    final TextEditingController sizeController = TextEditingController(
      text: company.companySize,
    );
    final TextEditingController locationController = TextEditingController(
      text: company.location,
    );
    final TextEditingController emailController = TextEditingController(
      text: company.email,
    );
    final TextEditingController companyTypeController = TextEditingController(
      text: company.companyType,
    );
    final TextEditingController industryController = TextEditingController(
      text: company.industry,
    );
    final TextEditingController overviewController = TextEditingController(
      text: company.overview,
    );
    final TextEditingController foundedController = TextEditingController(
      text: company.founded.toString(),
    );
    final TextEditingController websiteController = TextEditingController(
      text: company.website,
    );
    final TextEditingController addressController = TextEditingController(
      text: company.address,
    );
    final TextEditingController contactNumberController = TextEditingController(
      text: company.contactNumber,
    );

    // Controllers for image upload
    File? logoImage;
    File? bannerImage;

    final ImagePicker _picker = ImagePicker();

    Future<void> _pickImage(ImageSource source, bool isLogo) async {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        if (isLogo) {
          logoImage = File(pickedFile.path);
        } else {
          bannerImage = File(pickedFile.path);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Company Details')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<EditCompanyDetailsProvider>(
          builder: (context, provider, child) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        AddAdminScreen(companyId: companyId),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.person_add,
                            color: Colors.white,
                          ), // User+ Icon
                          label: Text('Add Page Admin'),
                        ),
                      ],
                    ),
                    // Company Name Field
                    buildField(
                      'Company Name',
                      nameController,
                      validator: requiredValidator,
                    ),
                    // Description Field
                    buildField(
                      'Description',
                      descriptionController,
                      maxLines: 3,
                    ),
                    // Company Size Dropdown Field
                    buildDropdownField(
                      'Company Size',
                      sizeController,
                      companySizeOptions,
                    ),
                    // Location Field
                    buildField(
                      'Location',
                      locationController,
                      validator: urlValidator,
                    ),
                    // Email Field
                    buildField(
                      'Email',
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                    // Company Type Field
                    buildDropdownField(
                      'Company Type',
                      companyTypeController,
                      companyTypeOptions,
                    ),
                    // Industry Field
                    buildField(
                      'Industry',
                      industryController,
                      validator: requiredValidator,
                    ),
                    // Overview Field
                    buildField('Overview', overviewController, maxLines: 4),
                    // Founded Year Field
                    buildField('Founded Year', foundedController),
                    // Website Field
                    buildField(
                      'Website',
                      websiteController,
                      keyboardType: TextInputType.url,
                      validator: urlValidator,
                    ),
                    // Address Field
                    buildField('Address', addressController),
                    // Contact Number Field
                    buildField(
                      'Contact Number',
                      contactNumberController,
                      keyboardType: TextInputType.phone,
                    ),

                    // Company Logo Image Picker
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Logo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          GestureDetector(
                            onTap:
                                () => provider.pickImage(
                                  ImageSource.gallery,
                                  true,
                                ), // true for logo
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                // If logo image is available, display it
                                provider.logoImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(provider.logoImage!.path),
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.25,
                                        height:
                                            MediaQuery.of(context).size.width *
                                            0.25, 
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : company.logo != null &&
                                        company.logo.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        company.logo,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.25,
                                        height:
                                            MediaQuery.of(context).size.width *
                                            0.25,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(width: 1.5),
                                      ),
                                      child: Icon(Icons.photo_camera, size: 30),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Company Banner Image Picker
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Banner',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Banner image picker
                          GestureDetector(
                            onTap:
                                () => provider.pickImage(
                                  ImageSource.gallery,
                                  false,
                                ), 
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                provider.bannerImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(provider.bannerImage!.path),
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.75,
                                        height:
                                            MediaQuery.of(context).size.width *
                                            0.25, 
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : company.banner != null &&
                                        company.banner.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        company.banner,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.75,
                                        height:
                                            MediaQuery.of(context).size.width *
                                            0.25,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.75,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(width: 1.5),
                                      ),
                                      child: Icon(Icons.photo_camera, size: 30),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    if (provider.isLoading)
                      Center(child: CircularProgressIndicator()),
                    if (provider.errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          provider.errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    // Update Company Button
                    ElevatedButton(
                      onPressed:
                          provider.isLoading
                              ? null
                              : () async {
                                if (_formKey.currentState!.validate()) {
                                  final updatedCompany = UpdateCompanyEntity(
                                    name: nameController.text,
                                    description: descriptionController.text,
                                    companySize: sizeController.text,
                                    location: locationController.text,
                                    email: emailController.text,
                                    companyType: companyTypeController.text,
                                    industry: industryController.text,
                                    overview: overviewController.text,
                                    founded:
                                        int.tryParse(foundedController.text) ??
                                        2000,
                                    website: websiteController.text,
                                    address: addressController.text,
                                    contactNumber: contactNumberController.text,
                                    logo:
                                        logoImage?.path ??
                                        company.logo, 
                                    banner:
                                        bannerImage?.path ??
                                        company
                                            .banner, 
                                    isVerified: company.isVerified,
                                  );
                                  await provider.updateDetails(
                                    updatedCompany,
                                    companyId,
                                  );
                                  if (provider.errorMessage.isEmpty) {
                                    Navigator.pop(context, true);
                                  }
                                }
                              },
                      child: Text('Update Company'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white, // Set background color to white
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: hintText,
            ),
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField(
    String label,
    TextEditingController controller,
    List<String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          DropdownButtonFormField2<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white, // Set background color to white
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            value: controller.text.isNotEmpty ? controller.text : null,
            onChanged: (String? value) {
              controller.text = value!;
            },
            items:
                items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? emailValidator(String? value) {
    final emailPattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? urlValidator(String? value) {
    final urlPattern =
        r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(\S*)?$';
    if (value == null || value.isEmpty) return null;

    if (!RegExp(urlPattern).hasMatch(value)) {
      return 'Enter a valid URL';
    }
    return null;
  }
}
