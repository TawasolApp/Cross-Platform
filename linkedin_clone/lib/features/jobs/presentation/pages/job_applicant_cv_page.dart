import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modifiedUrl = pdfUrl.replaceAll('.pdf', '');
    final googleViewerUrl =
        'https://drive.google.com/viewerng/viewer?embedded=true&url=$modifiedUrl';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Viewer'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: ElevatedButton(
                        key: const ValueKey('open_resume_button'),

          onPressed: () async {
            if (await canLaunchUrl(Uri.parse(googleViewerUrl))) {
              await launchUrl(
                Uri.parse(googleViewerUrl),
                mode: LaunchMode.externalApplication,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cannot open document')),
              );
            }
          },
          child: const Text('Open Resume in Browser'),
        ),
      ),
    );
  }
}
