import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/update_provider.dart';
import 'package:jjm_wqmis/utils/update_dialog.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.sanitizePrefs();  // await clear
      await session.init();       // await init after clearing
      await _checkForUpdateAndNavigate(); // navigate after setup
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
