import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaPage extends StatefulWidget {
  final ValueChanged<String> onVerified;

  const RecaptchaPage({Key? key, required this.onVerified}) : super(key: key);

  @override
  _RecaptchaPageState createState() => _RecaptchaPageState();
}

class _RecaptchaPageState extends State<RecaptchaPage> {
  late final WebViewController _controller;
  final Completer<WebViewController> _controllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('Captcha', onMessageReceived: (message) {
        widget.onVerified(message.message);
        Navigator.of(context).pop();
      })
      ..loadRequest(Uri.dataFromString(
        _getHtmlContent(),
        mimeType: 'text/html',
      ));

    _controllerCompleter.complete(_controller);
  }

  String _getHtmlContent() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>reCAPTCHA Verification</title>
    <script src="https://www.google.com/recaptcha/api.js?onload=onRecaptchaLoad&render=explicit" async defer></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
        }
        .recaptcha-container {
            margin: 20px;
        }
    </style>
</head>
<body>
    <div class="recaptcha-container">
        <div id="recaptcha-widget"></div>
    </div>
    <script>
        var onRecaptchaLoad = function() {
            grecaptcha.render('recaptcha-widget', {
                'sitekey': '6LcMAAsrAAAAAAEcOoshJFfHmsQZPaWg6cKVqZz8', // Replace with your actual Android site key
                'theme': 'light',
                'size': 'normal',
                'callback': function(response) {
                    Captcha.postMessage(response);
                },
                'expired-callback': function() {
                    Captcha.postMessage('expired');
                },
                'error-callback': function() {
                    Captcha.postMessage('error');
                }
            });
        };
    </script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify you're human"),
        centerTitle: true,
      ),
      body: FutureBuilder<WebViewController>(
        future: _controllerCompleter.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WebViewWidget(controller: _controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}