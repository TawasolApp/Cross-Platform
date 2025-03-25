import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_create_provider.dart';

class CreateCompanyScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  void _pickImage(BuildContext context, bool isLogo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final provider = Provider.of<CompanyCreateProvider>(
        context,
        listen: false,
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
                                        border: Border.all(
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.photo_camera,
                                        size: 30,
                                      ),
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
                      DropdownButtonFormField<String>(
                        value: provider.selectedIndustry,
                        items:
                            ["Technology", "Healthcare", "Finance"]
                                .map(
                                  (industry) => DropdownMenuItem(
                                    value: industry,
                                    child: Text(industry),
                                  ),
                                )
                                .toList(),
                        onChanged: provider.setIndustry,
                        decoration: InputDecoration(
                          labelText: "Industry *",
                          prefixIcon: Icon(Icons.category),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value == null
                                    ? "Please select an industry"
                                    : null,
                      ),
                      SizedBox(height: 16),

                      // ✅ Location Dropdown
                      DropdownButtonFormField<String>(
                        value: provider.selectedLocation,
                        items:
                            ["Cairo", "Dubai", "San Francisco"]
                                .map(
                                  (location) => DropdownMenuItem(
                                    value: location,
                                    child: Text(location),
                                  ),
                                )
                                .toList(),
                        onChanged: provider.setLocation,
                        decoration: InputDecoration(
                          labelText: "Location",
                          prefixIcon: Icon(Icons.location_on),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),

                      // ✅ Website (Required)
                      TextFormField(
                        onChanged: provider.setWebsite,
                        decoration: InputDecoration(
                          labelText: "Website *",
                          prefixIcon: Icon(Icons.link),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? "Please enter the company's website"
                                    : null,
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
