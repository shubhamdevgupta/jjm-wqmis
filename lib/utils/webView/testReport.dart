import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestReport extends StatefulWidget {
  final String url;

  const TestReport({super.key, required this.url});

  @override
  State<TestReport> createState() => _TestReportState();
}

class _TestReportState extends State<TestReport> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(8),
            right: Radius.circular(8),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
            }),
        title: const Text(
          'FTK Report',
          style: TextStyle( fontFamily: 'OpenSans',color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF096DA8), // Dark blue color
                Color(0xFF3C8DBC), // jjm blue color
              ],
              begin: Alignment.topCenter, // Start at the top center
              end: Alignment.bottomCenter, // End at the bottom center
            ),
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );}
}
