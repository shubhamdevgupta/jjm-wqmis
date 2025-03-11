import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ErrorProvider.dart';

class ExceptionScreen extends StatelessWidget {
  final bool allowBackNavigation;

  const ExceptionScreen({Key? key, this.allowBackNavigation = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorProvider = Provider.of<ErrorProvider>(context);

    return WillPopScope(
      // ✅ Prevents going back if allowBackNavigation is false
      onWillPop: () async => allowBackNavigation,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Something Went Wrong'),
          automaticallyImplyLeading:
              allowBackNavigation, // ✅ Show/hide back button
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 80),
                const SizedBox(height: 20),
                Text(
                  errorProvider.errorMessage ?? "An unexpected error occurred",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    errorProvider.clearError();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
