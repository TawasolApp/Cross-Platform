import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_create_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CreateCompanyScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  void _pickImage(BuildContext context, bool isLogo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final provider = Provider.of<CompanyCreateProvider>(
        context,
        listen: true,
      );
      isLogo ? provider.setLogoImage(image) : provider.setBannerImage(image);
    }
  }

  void _submitForm(BuildContext context) async {
    final provider = Provider.of<CompanyCreateProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      if (provider.logoImage == null || provider.bannerImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please upload both company logo and banner."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newCompany = await provider.createCompany();
      if (newCompany != null && !provider.isLoading) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Create Tawasol Page")),
      body: Consumer<CompanyCreateProvider>(
        builder: (context, provider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Logo Upload + Company Name Field
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ✅ Upload Logo Button
                          GestureDetector(
                            onTap: () => _pickImage(context, true),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                provider.logoImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(provider.logoImage!.path),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(width: 1.5),
                                      ),
                                      child: Icon(Icons.photo_camera, size: 30),
                                    ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),

                          // ✅ Company Name Field
                          Expanded(
                            child: TextFormField(
                              onChanged: provider.setName,
                              decoration: InputDecoration(
                                labelText: "Company Name *",
                                prefixIcon: Icon(Icons.business),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? "Please enter a company name"
                                          : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // ✅ Industry Dropdown
                      DropdownButtonFormField2<String>(
                        value: provider.selectedIndustry,
                        onChanged: provider.setIndustry,
                        decoration: InputDecoration(
                          labelText: "Industry *",
                          prefixIcon: Icon(Icons.people),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                        ),
                        isDense: true,
                        isExpanded: true,

                        // ✅ Customizes dropdown appearance
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          offset: Offset(0, 5),
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),

                        // ✅ Scrollable dropdown menu
                        items:
                            [
                                  "Health Care",
                                  "Technology",
                                  "Finance",

                                ]
                                .map(
                                  (size) => DropdownMenuItem(
                                    value: size,
                                    child: Text(
                                      size,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),

                        validator:
                            (value) =>
                                value == null
                                    ? "Please select a company size"
                                    : null,
                      ),
                      SizedBox(height: 16),

                      // ✅ Location Dropdown
                      TextFormField(
                        onChanged: provider.setLocation,
                        decoration: InputDecoration(
                          labelText: "Location *",
                          prefixIcon: Icon(Icons.location_on),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Please enter a location"
                                    : null,
                      ),
                      SizedBox(height: 16),
                      // ✅ Company Size Dropdown
                      DropdownButtonFormField2<String>(
                        value: provider.selectedCompanySize,
                        onChanged: provider.setCompanySize,
                        decoration: InputDecoration(
                          labelText: "Company Size *",
                          prefixIcon: Icon(Icons.people),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                        ),
                        isDense: true,
                        isExpanded: true,

                        // ✅ Customizes dropdown appearance
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          offset: Offset(0, 5),
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),

                        // ✅ Scrollable dropdown menu
                        items:
                            [
                                  "0-1 Employees",
                                  "2-10 Employees",
                                  "11-50 Employees",
                                  "51-200 Employees",
                                  "201-500 Employees",
                                  "501-1000 Employees",
                                  "1001-5000 Employees",
                                  "5001-10,000 Employees",
                                  "10,000+ Employees",
                                ]
                                .map(
                                  (size) => DropdownMenuItem(
                                    value: size,
                                    child: Text(
                                      size,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),

                        validator:
                            (value) =>
                                value == null
                                    ? "Please select a company size"
                                    : null,
                      ),
                      SizedBox(height: 16),
                      // ✅ Website (Required with Validation)
                      TextFormField(
                        onChanged: provider.setWebsite,
                        decoration: InputDecoration(
                          labelText: "Website *",
                          prefixIcon: Icon(Icons.link),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the company's website";
                          }
                          // Validate a proper URL format
                          final urlPattern =
                              r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(\S*)?$';
                          final regExp = RegExp(urlPattern);

                          if (!regExp.hasMatch(value)) {
                            return "Please enter a valid website URL (e.g., https://example.com)";
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // ✅ Company Banner Picker
                      Row(
                        children: [
                          provider.bannerImage != null
                              ? Image.file(
                                File(provider.bannerImage!.path),
                                width: 120,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                              : Icon(Icons.image, size: 60),
                          SizedBox(width: 12),
                          TextButton.icon(
                            onPressed: () => _pickImage(context, false),
                            icon: Icon(Icons.upload),
                            label: Text("Upload Banner"),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // ✅ Description Field
                      TextFormField(
                        onChanged: provider.setDescription,
                        decoration: InputDecoration(
                          labelText: "Description *",
                          prefixIcon: Icon(Icons.description),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? "Please enter a description"
                                    : null,
                      ),
                      SizedBox(height: 20),

                      // ✅ Submit Button
                      provider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                            onPressed: () => _submitForm(context),
                            child: Text("Create Page"),
                          ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
