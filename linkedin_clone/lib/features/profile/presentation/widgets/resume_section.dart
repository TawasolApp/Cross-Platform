import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/domain/repositories/media_repository.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/company/domain/usecases/upload_document_use_case.dart';
import 'package:linkedin_clone/features/jobs/presentation/pages/job_applicant_cv_page.dart';

class ResumeSection extends StatefulWidget {
  final String? resumeUrl;
  final bool isCurrentUser;
  final String? errorMessage;

  const ResumeSection({
    Key? key,
    this.resumeUrl,
    this.isCurrentUser = false,
    this.errorMessage,
  }) : super(key: key);

  @override
  State<ResumeSection> createState() => _ResumeSectionState();
}

class _ResumeSectionState extends State<ResumeSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final resumeUrl = widget.resumeUrl ?? provider.resume;
        final error = widget.errorMessage ?? provider.resumeError;
        final isLoading = provider.isLoading;

        return Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(provider),
                const SizedBox(height: 16),
                _buildResumeContent(resumeUrl, isLoading, provider),

                // Error Message
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(ProfileProvider provider) {
    final hasResume =
        widget.resumeUrl != null ||
        (provider.resume != null && provider.resume!.isNotEmpty);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Resume',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        if (widget.isCurrentUser && hasResume)
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
            onPressed: () => _pickResumeFile(provider),
          ),
      ],
    );
  }

  Widget _buildResumeContent(
    String? resumeUrl,
    bool isLoading,
    ProfileProvider provider,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (resumeUrl == null || resumeUrl.isEmpty) {
      return _buildEmptyState(provider);
    }

    return _buildResumeItem(resumeUrl);
  }

  Widget _buildEmptyState(ProfileProvider provider) {
    if (widget.isCurrentUser) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 40,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'Add a resume to help recruiters find you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PDF, DOC, DOCX files up to 10MB',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => _pickResumeFile(provider),
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload resume'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.description_outlined, size: 32, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'No resume available',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildResumeItem(String resumeUrl) {
    final fileName = _getFileNameFromUrl(resumeUrl);
    final fileType = _getFileTypeFromUrl(resumeUrl);
    final fileIcon = _getFileIcon(fileType);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: fileIcon,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fileType.toUpperCase(),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye_outlined),
            tooltip: 'View',
            onPressed: () => _viewResume(resumeUrl),
            color: Theme.of(context).primaryColor,
          ),
          // IconButton(
          //   icon: const Icon(Icons.download_outlined),
          //   tooltip: 'Download',
          //   onPressed: () => _downloadResume(resumeUrl),
          //   color: Theme.of(context).primaryColor,
          // ),
        ],
      ),
    );
  }

  String _getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    String fileName = path.basename(uri.path);
    // Remove any query parameters if present
    fileName = fileName.split('?').first;
    return fileName.length > 20 ? '${fileName.substring(0, 17)}...' : fileName;
  }

  String _getFileTypeFromUrl(String url) {
    final fileName = _getFileNameFromUrl(url);
    return fileName.split('.').last.toLowerCase();
  }

  Widget _getFileIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description, color: Colors.blue);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }
  }

  Future<void> _pickResumeFile(ProfileProvider provider) async {
    print('📤 Upload resume function triggered');

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final pickedFile = XFile(path);
        print('📁 File picked: ${pickedFile.name}');

        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uploading resume...'),
            duration: Duration(seconds: 30),
          ),
        );

        final mediaRepository = Provider.of<MediaRepository>(
          context,
          listen: false,
        );

        try {
          final url = await mediaRepository.uploadDocument(pickedFile);
          print('✅ Upload completed. URL: $url');

          // Update the resume in the provider with the actual URL
          await provider.updateResume(url);

          // Hide the loading indicator and show success message
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resume uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          print('❌ Upload failed: $e');
          // Hide any existing snackbar and show error message
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading resume: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print('❌ No file selected');
      }
    } catch (e) {
      print('❌ Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _viewResume(String url) async {
    print('👁️ Viewing resume file: $url');

    try {
      // Navigate to the PdfViewerScreen instead of launching URL directly
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfViewerScreen(pdfUrl: url)),
      );
      print('✅ PDF viewer opened successfully');
    } catch (e) {
      print('❌ Error opening PDF viewer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening resume: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadResume(String url) async {
    print('⬇️ Downloading resume file: $url');

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        print('🔗 Launching download URL');
        await launchUrl(uri);
        print('✅ Download initiated successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resume download started'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('❌ Cannot launch download URL: $url');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not download the resume file'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error downloading resume: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading resume: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
