import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:file_picker/file_picker.dart';

class ApplyForJobWidget extends StatelessWidget {
  final String companyName;
  ApplyForJobWidget({required this.companyName});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isResumeUploaded = false;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US'); // Default country code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.white, 
        title: Text(
          'Apply for $companyName',
          style: TextStyle(color: const Color.fromARGB(255, 21, 98, 161)), 
        ),
        iconTheme: IconThemeData(color: Colors.black), 
        elevation: 0, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Personal Details',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              // Name input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Email input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Phone number input with country code dropdown
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _phoneNumber = number;
                },
                initialValue: _phoneNumber,
                textFieldController: _phoneController,
                inputDecoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                countries: [],
              ),
              SizedBox(height: 16),
              // Resume upload section
              ElevatedButton(
                onPressed: () => _uploadResume(context),
                child: Text(
                  _isResumeUploaded ? 'Resume Uploaded' : 'Upload Resume',
                ),
              ),
              SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: () => _applyForJob(context),
                child: Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Handle job application submission
  void _applyForJob(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application Submitted Successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all required fields')),
      );
    }
  }

  // Handle file upload
  void _uploadResume(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // Specify allowed extensions
    );

    if (result != null) {
      // You can get the file path and upload it to your backend
      String filePath = result.files.single.path ?? '';
      _isResumeUploaded = true;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Resume Uploaded Successfully')));
    } else {
      // User canceled the file picker
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No file selected')));
    }
  }
}
