import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ErrorProvider.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/providers/SampleListProvider.dart';
import 'package:jjm_wqmis/providers/SampleSubmitProvider.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/dashboardProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/views/DWSM/dwsm_Dashboard.dart';
import 'package:jjm_wqmis/views/DWSM/submit_info.dart';
import 'package:jjm_wqmis/views/auth/DashboardScreen.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/views/SampleListScreen.dart';
import 'package:jjm_wqmis/views/LocationScreen.dart';
import 'package:jjm_wqmis/views/auth/LoginScreen.dart';
import 'package:jjm_wqmis/views/SampleInformationScreen.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';
import 'package:jjm_wqmis/views/auth/SplashScreen.dart';
import 'package:jjm_wqmis/views/lab/LabParameterScreen.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => Masterprovider()),
        ChangeNotifierProvider(create: (context) => ErrorProvider()),
        ChangeNotifierProvider(create: (context) => ParameterProvider()),
        ChangeNotifierProvider(create: (context) => Samplesubprovider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => Samplelistprovider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // '/': (context) => SelectedTestNew(),
       '/': (context) => SplashScreen(),
        AppConstants.navigateToSaveSample: (context) => Sampleinformationscreen(),
        AppConstants.navigateToDashboard: (context) => Dashboardscreen(),
        AppConstants.navigateToLogin: (context) => Loginscreen(),
        AppConstants.navigateToLocation: (context) => Locationscreen(flag: 0,),
        AppConstants.navigateToLabParam: (context) => Labparameterscreen(),
        AppConstants.navigateToTest: (context) => SubmitSampleScreen(),
        AppConstants.navigateToSampleList: (context) => SampleListScreen(),
        AppConstants.navigateToSubmit_info: (context) => SubmitInfo()
      },
    );
  }
}
