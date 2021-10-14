import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/app_logo.png',
        ),
        centerTitle: true,
        toolbarHeight: 44,
      ),
      body: const WebView(initialUrl: 'https://prod-swing-trimmer.web.app/'),
    );
  }
}
