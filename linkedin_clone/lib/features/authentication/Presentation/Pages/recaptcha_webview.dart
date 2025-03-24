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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            // Inject JavaScript to handle the callback
            _controller.runJavaScript('''
              function onSuccess(token) {
                RecaptchaChannel.postMessage(token);
              }
              if (typeof window.RecaptchaChannel === 'undefined') {
                window.RecaptchaChannel = {
                  postMessage: function(message) {
                    window.flutter_inappwebview.callHandler('recaptchaCallback', message);
                  }
                };
              }
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse('http://localhost:8000/recaptcha.html'));
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
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}