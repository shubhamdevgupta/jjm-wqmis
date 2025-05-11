import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/UpdateProvider.dart';
import '../../services/LocalStorageService.dart';
import '../../utils/UpdateDialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorageService localStorage = LocalStorageService();
  final UpdateViewModel _updateViewModel = UpdateViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdateAndNavigate();
    });
  }

  Future<void> _checkForUpdateAndNavigate() async {
    bool isAvailable = await _updateViewModel.checkForUpdate();
    print('Update available: $isAvailable');

    if (isAvailable && mounted) {
      final updateInfo = await _updateViewModel.getUpdateInfo();

      if (updateInfo != null) {
        print("Dialog will show with: ${updateInfo.apkUrl}, ${updateInfo.whatsNew}");

        // Show dialog and stop further navigation until user interacts
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('Update Available'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What\'s New:'),
                SizedBox(height: 8),
                Text(updateInfo.whatsNew),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Update Now'),
                onPressed: () async {
                  final url = updateInfo.apkUrl;
                  final uri = Uri.parse(url);
                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ],
          ),
        );
        return;
      }
    }
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 1)); // Optional splash delay

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final roleId = localStorage.getString(AppConstants.prefRoleId);
    await authProvider.checkLoginStatus();

    if (authProvider.isLoggedIn) {
      if (roleId == "4") {
        Navigator.pushReplacementNamed(context, AppConstants.navigateToDashboard);
      } else if (roleId == "8") {
        Navigator.pushReplacementNamed(context, AppConstants.navigateToDwsmDashboard);
      }
    } else {
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
