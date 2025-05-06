import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkedin_clone/features/company/domain/repositories/media_repository.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_apply_provider.dart';
import 'package:provider/provider.dart';

class ApplyForJobWidget extends StatefulWidget {
  final String companyName;
  final String jobId;

  const ApplyForJobWidget({
    required this.companyName,
    required this.jobId,
    Key? key,
  }) : super(key: key);

  @override
  State<ApplyForJobWidget> createState() => _ApplyForJobWidgetState();
}

class _ApplyForJobWidgetState extends State<ApplyForJobWidget> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'EG');

  XFile? _selectedCV;
  String? _uploadedCVUrl;
  String _cvFileName = 'No file selected';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Apply for ${widget.companyName}',
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
              Text(
                'Upload Your CV (PDF)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (_uploadedCVUrl != null)
                    Expanded(
                      child: Text(_cvFileName, overflow: TextOverflow.ellipsis),
                    ),
                  TextButton(
                    key: const ValueKey('upload_cv_button'),
                    onPressed: () async {
                      print('📤 Upload button pressed');
                      await _pickAndUploadCV(context);
                    },
                    child: const Text('Upload CV'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const ValueKey('submit_application_button'),
                onPressed: () => _applyForJob(context),
                child: const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadCV(BuildContext context) async {
    print('📤 Upload CV function triggered');

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final pickedFile = XFile(path);
      print('📁 File picked: ${pickedFile.name}');

      final mediaProvider = Provider.of<MediaRepository>(
        context,
        listen: false,
      );
      try {
        final url = await mediaProvider.uploadDocument(pickedFile);
        setState(() {
          _uploadedCVUrl = url;
          _cvFileName = pickedFile.name;
        });
        print('✅ Upload completed. URL: $url');
      } catch (e) {
        print('❌ Upload failed: $e');
      }
    } else {
      print('❌ No file selected');
    }
  }

  Future<void> _applyForJob(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ApplyJobProvider>(context, listen: false);

      final application = ApplyForJobEntity(
        jobId: widget.jobId,
        phoneNumber: _phoneNumber.phoneNumber ?? '',
        resumeURL: _uploadedCVUrl ?? '',
      );
      print(
        '📄 Applying for job with application CV URL: ${application.resumeURL}',
      );
      bool success = await provider.applyForJob(application);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Application Submitted Successfully!'
                : 'Application Failed',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pop(context, true);
      }
    }
  }
}
