import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/services/AppResetService.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/utils/AppStyles.dart';

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
                  if(errorCode=="401"){
                    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
                    await authProvider.logoutUser();
                    Navigator.of(context).pop(); // ✅ This dismisses the dialog
                    await AppResetService.fullReset(context);
                    Navigator.pushNamedAndRemoveUntil(context, AppConstants.navigateToLoginScreen,
                          (route) => false,
                    );
                  }
                  Navigator.of(context).pop();
                },
                child:  Text('OK' , style: AppStyles.setTextStyle(16, FontWeight.bold, Colors.red, ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
