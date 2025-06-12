import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/ErrorProvider.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';

class ExceptionScreen extends StatelessWidget {
  final String errorMessage;

  const ExceptionScreen({super.key, required this.errorMessage});

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
                'assets/icons/ic_error.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black87, fontFamily: 'OpenSans',),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  errorProvider.clearError();
                  Navigator.of(context).pop(); // ✅ This dismisses the dialog
                },
                child:  Text('Dismiss' , style: AppStyles.setTextStyle(16, FontWeight.bold, Colors.red, ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
