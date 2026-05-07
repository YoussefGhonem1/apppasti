import 'package:flutter/material.dart';
import 'package:pasti/models/settings.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(settings.termsLink));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1('Termini & Condizioni'),
      body: WebViewWidget(controller: _controller),
    );
  }
}
