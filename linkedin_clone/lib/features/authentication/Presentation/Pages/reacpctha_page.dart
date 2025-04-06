import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaPage extends StatefulWidget {
  final Function(String) onVerified;

  const RecaptchaPage({Key? key, required this.onVerified}) : super(key: key);

  @override
  _RecaptchaPageState createState() => _RecaptchaPageState();
}

class _RecaptchaPageState extends State<RecaptchaPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains("success=true")) {
              // Extract the token from the URL or WebView page
              _controller.runJavaScriptReturningResult(
                "document.getElementById('recaptcha-token').value;"
              ).then((token) {
                if (token != null && token.toString().isNotEmpty) {
                  widget.onVerified(token.toString());
                  Navigator.pop(context, token.toString());
                } else {
                  widget.onVerified('error');
                  Navigator.pop(context, 'error');
                }
              });
            } else if (url.contains("error=true")) {
              widget.onVerified('error');
              Navigator.pop(context, 'error');
            } else if (url.contains("expired=true")) {
              widget.onVerified('expired');
              Navigator.pop(context, 'expired');
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://tawasolapp.me/recaptcha'), // Your hosted reCAPTCHA page
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("reCAPTCHA Verification"),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
