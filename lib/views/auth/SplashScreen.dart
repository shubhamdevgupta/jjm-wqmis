import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/UpdateProvider.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/utils/UpdateDialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final session = UserSessionManager();
  final UpdateViewModel _updateViewModel = UpdateViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     // _checkForUpdateAndNavigate();
      _navigateToNextScreen();
       session.init();
    });
  }

  Future<void> _checkForUpdateAndNavigate() async {
    bool isAvailable = await _updateViewModel.checkForUpdate();

    if (isAvailable && mounted) {
      final updateInfo = await _updateViewModel.getUpdateInfo();

      if (updateInfo != null) {

        DialogUtils.showUpdateDialog(context, updateInfo);
        return;
      }
    }
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1)); // Optional splash delay

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final roleId = session.roleId;
    await authProvider.checkLoginStatus();
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
