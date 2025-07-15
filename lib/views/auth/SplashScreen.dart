import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final session = UserSessionManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.sanitizePrefs();  // await clear
      await session.init();
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final masterProvider = Provider.of<Masterprovider>(context, listen: false);
    final roleId = session.roleId;
    await authProvider.checkLoginStatus();
    masterProvider.clearData();
    if (authProvider.isLoggedIn) {
      if (roleId == 4) {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToDashboardScreen);
      } else if (roleId == 8) {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToDwsmDashboard);
      } else if (roleId == 7) {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToFtkDashboard);
      }
    } else {
      Navigator.pushReplacementNamed(
          context, AppConstants.navigateToLoginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/wqmis_splash.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
