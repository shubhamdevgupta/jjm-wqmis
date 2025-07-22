import 'package:flutter/material.dart';
import 'package:jjm_wqmis/services/app_reset_service.dart';

import 'package:jjm_wqmis/utils/app_style.dart';

class ExceptionScreen extends StatelessWidget {
  final String errorMessage;
  final String errorCode;

  const ExceptionScreen({super.key, required this.errorMessage,required this.errorCode});

  @override
  Widget build(BuildContext context) {

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
                onPressed: () async {
                  if (errorCode == "401") {
                    await AppResetService.fullReset(context);
                  } else {
                    if (context.mounted) Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'OK',
                    style: AppStyles.setTextStyle(16, FontWeight.bold, Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
