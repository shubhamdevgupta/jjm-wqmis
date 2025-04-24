import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ErrorProvider.dart';
import '../utils/AppConstants.dart';
import '../utils/AppStyles.dart';

class ExceptionScreen extends StatelessWidget {
  final String errorMessage;

  const ExceptionScreen({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorProvider = Provider.of<ErrorProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevents full height usage
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             // const Icon(Icons.error, color: Colors.red, size: 80),
              const SizedBox(height: 35),
              Image.asset(
                'assets/ic_error.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  errorProvider.clearError();
                  Navigator.of(context).pop(); // ✅ This dismisses the dialog
                },
                child:  Text('Dismiss' , style: AppStyles.setTextStyle(16, FontWeight.bold, Colors.red),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}