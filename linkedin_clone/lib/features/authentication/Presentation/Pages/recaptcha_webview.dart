import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaWebView extends StatefulWidget {
  final Function(String token) onVerified;

  const RecaptchaWebView({super.key, required this.onVerified});

  @override
  State<RecaptchaWebView> createState() => _RecaptchaWebViewState();
}

class _RecaptchaWebViewState extends State<RecaptchaWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'RecaptchaChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final token = message.message;
          Navigator.of(context).pop(); // Close dialog
          widget.onVerified(token);   // Pass token to caller
        },
      )
      ..loadFlutterAsset('assets/html/recaptcha.html'); // Load your HTML from assets
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 400,
          width: double.infinity,
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
