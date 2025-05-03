import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/premium/presentations/provider/premium_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PremiumCheckoutPage extends StatefulWidget {
  final String checkoutUrl;

  const PremiumCheckoutPage({super.key, required this.checkoutUrl});

  @override
  State<PremiumCheckoutPage> createState() => _PremiumCheckoutPageState();
}

class _PremiumCheckoutPageState extends State<PremiumCheckoutPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains('current')) {
                  // User completed payment
                  Navigator.pop(context, true); // return true
                  return NavigationDecision.prevent;
                } else if (request.url.contains('rejected')) {
                  // User cancelled payment
                  Navigator.pop(context, false);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Premium Checkout")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
