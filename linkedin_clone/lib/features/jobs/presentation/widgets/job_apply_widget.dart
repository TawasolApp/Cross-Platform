import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_apply_provider.dart';
import 'package:provider/provider.dart';

class ApplyForJobWidget extends StatelessWidget {
  final String companyName;
  final String jobId;

  ApplyForJobWidget({required this.companyName, required this.jobId});

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'EG'); // Default country code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Apply for $companyName',
          style: const TextStyle(color: Color.fromARGB(255, 21, 98, 161)),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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
              const SizedBox(height: 16),

              const SizedBox(height: 16),

              const SizedBox(height: 16),
              // Phone Number
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _phoneNumber = number;
                },
                initialValue: _phoneNumber,
                textFieldController: _phoneController,
                inputDecoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                countries: [],
              ),
              const SizedBox(height: 24),
              // Submit Button
              ElevatedButton(
                onPressed: () => _applyForJob(context),
                child: const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Handle form submission
  void _applyForJob(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ApplyJobProvider>(context, listen: false);

      final application = ApplyForJobEntity(
        jobId: jobId,
        phoneNumber: _phoneNumber.phoneNumber ?? '',
        resumeURL: '',
      );

      bool success = await provider.applyForJob(application);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Application Submitted Successfully!'
                : 'Application Failed ',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      // Delay then close screen
      await Future.delayed(const Duration(milliseconds: 500));
      if (success) {
        // Close the screen if the application was successful
        Navigator.pop(context);
      } else {
        // Optionally, you can keep the screen open for the user to try again
      }
    }
  }
}
