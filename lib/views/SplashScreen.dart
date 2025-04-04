// Import necessary packages
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/utils/Strings.dart';
import 'dart:async';

import 'package:jjm_wqmis/views/LoginScreen.dart';
import 'package:provider/provider.dart';

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // SplashScreen Duration

    // Check Login Status using ViewModel
    var authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.checkLoginStatus();

    if (authProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(context, Strings.navigateToDashboard);
    } else {
      Navigator.pushReplacementNamed(context, Strings.navigateToLogin);
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
