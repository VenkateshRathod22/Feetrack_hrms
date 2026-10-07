import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url, title;
  const CustomWebView({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final WebViewController controller = WebViewController();
  late String url;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    if (!(url.startsWith('http'))) {
      if (!(url.startsWith('https://'))) {
        url = 'https://$url';
      }
    }

    controller
      ..loadRequest(Uri.parse(url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progressValue) {
            setState(() {
              progress = progressValue / 100; // Convert to percentage
            });
          },
          onPageFinished: (url) {
            setState(() {
              progress = 0.0; // Hide progress bar after loading
            });
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    log(url);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          if (progress > 0.0)
            LinearProgressIndicator(value: progress, minHeight: 4),

          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
