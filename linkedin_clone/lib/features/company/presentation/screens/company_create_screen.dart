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
        listen: false,
      );

      if (isLogo) {
        provider.setCompanyLogo(image);
      } else {
        provider.setCompanyBanner(image);
      }
    }
  }

  void _submitForm(BuildContext context) async {
    final provider = Provider.of<CompanyCreateProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      print("Form validated! Submitting...");

      final newCompany = await provider.createCompany();
      print("New Company: $newCompany");

      if (newCompany != null && !provider.isLoading) {
        print("Company created successfully. Navigating back...");
        Navigator.pop(context);
      } else {
        print("Company creation failed or is still loading.");
      }
    } else {
      print("Form validation failed. Fix errors before submitting.");
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
                                provider.companyLogo != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(provider.companyLogo!.path),
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
                              onChanged: provider.setCompanyName,
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
                      // ✅ Overview Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            onChanged: provider.setCompanyOverview,
                            decoration: InputDecoration(
                              labelText: "Overview",
                              prefixIcon: Icon(Icons.description),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                            maxLength: 300,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null; 
                              }
                            },
                          ),
                          Text(
                            "Provide a short summary of your company, including its mission and services.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // ✅ Industry Field
                      TextFormField(
                        onChanged: provider.setCompanyIndustry,
                        decoration: InputDecoration(
                          labelText: "Industry *",
                          prefixIcon: Icon(Icons.factory),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Please enter an industry"
                                    : null,
                      ),
                      SizedBox(height: 16),
                      // ✅ Address Field
                      TextFormField(
                        onChanged: provider.setCompanyAddress,
                        decoration: InputDecoration(
                          labelText: "Address",
                          prefixIcon: Icon(Icons.home),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      // ✅ Location Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            onChanged: provider.setCompanyLocation,
                            decoration: InputDecoration(
                              labelText: "Location",
                              prefixIcon: Icon(Icons.location_on),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null; 
                              }

                              final urlPattern =
                                  r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(\S*)?$';
                              final regExp = RegExp(urlPattern);

                              if (!regExp.hasMatch(value)) {
                                return "Please enter a valid website URL (e.g., https://example.com)";
                              }

                              return null; 
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Paste your Google Maps location link here (e.g., https://maps.google.com/...).",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      // ✅ Company Size Field
                      DropdownButtonFormField2<String>(
                        value: provider.companySize,
                        onChanged: (value) {
                          if (value != null) {
                            provider.setCompanySize(value);
                          }
                        },
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
                                  "1-50 Employees",
                                  "51-400 Employees",
                                  "401-1000 Employees",
                                  "1001-10000 Employees",
                                  "10000+ Employees",
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
                      // ✅ Website Field
                      TextFormField(
                        onChanged: provider.setCompanyWebsite,
                        decoration: InputDecoration(
                          labelText: "Website",
                          prefixIcon: Icon(Icons.link),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; 
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

                      // ✅ Company Type Dropdown
                      DropdownButtonFormField2<String>(
                        value: provider.companyType,
                        onChanged: (value) {
                          if (value != null) {
                            provider.setCompanyType(value);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Company Type *",
                          prefixIcon: Icon(Icons.business_center),
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
                                  "Public Company",
                                  "Self Employed",
                                  "Government Agency",
                                  "Non Profit",
                                  "Sole Proprietorship",
                                  "Privately Held",
                                  "Partnership",
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
                                    ? "Please select a company type"
                                    : null,
                      ),
                      SizedBox(height: 16),
                      // ✅ Email Field
                      TextFormField(
                        onChanged: provider.setCompanyEmail,
                        decoration: InputDecoration(
                          labelText: "Email ",
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }

                          // ✅ Email validation regex pattern
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return "Please enter a valid email address";
                          }

                          return null; // Valid email
                        },
                      ),

                      SizedBox(height: 16),

                      // ✅ Contact Number Field
                      TextFormField(
                        onChanged: provider.setCompanyContactNumber,
                        decoration: InputDecoration(
                          labelText: "Contact Number ",
                          prefixIcon: Icon(Icons.call),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      // ✅ Founded Field
                      TextFormField(
                        onChanged: (value) {
                          final year = int.tryParse(value);
                          if (year != null) {
                            provider.setCompanyFounded(year);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Founded",
                          prefixIcon: Icon(Icons.calendar_today),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; 
                          }

                          final year = int.tryParse(value);
                          if (year == null ||
                              year < 1000 ||
                              year > DateTime.now().year) {
                            return "Please enter a valid year";
                          }

                          return null; // Valid year
                        },
                      ),
                      SizedBox(height: 16),
                      // ✅ Company Banner Picker
                      Row(
                        children: [
                          provider.companyBanner != null
                              ? Image.file(
                                File(provider.companyBanner!.path),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            onChanged: provider.setCompanyDescription,
                            decoration: InputDecoration(
                              labelText: "Description",
                              prefixIcon: Icon(Icons.article),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 4),
                        ],
                      ),

                      SizedBox(height: 16),

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
