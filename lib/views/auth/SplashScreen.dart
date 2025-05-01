// Import necessary packages
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'dart:async';

import 'package:jjm_wqmis/views/auth/LoginScreen.dart';
import 'package:provider/provider.dart';

import '../../services/LocalStorageService.dart';

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorageService localStorage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // SplashScreen Duration

    // Check Login Status using ViewModel
    var authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    var roleId=localStorage.getString(AppConstants.prefRoleId);
print("rollleeeeeeeeeeeeeeeeeeee $roleId");
    await authProvider.checkLoginStatus();

    if (authProvider.isLoggedIn) {
      if(roleId=="4") {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToDashboard);
      }else if(roleId=="8"){
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToDwsmDashboard);
      }    } else {
      Navigator.pushReplacementNamed(context, AppConstants.navigateToLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wqmis_splash.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}


// Main Entry Point
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}