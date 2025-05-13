import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/DashboardResponse/DwsmDashboardResponse.dart';
import 'package:jjm_wqmis/providers/ErrorProvider.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/providers/SampleListProvider.dart';
import 'package:jjm_wqmis/providers/SampleSubmitProvider.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/dashboardProvider.dart';
import 'package:jjm_wqmis/providers/dwsmProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/views/DWSM/DwsmDashboardScreen.dart';
import 'package:jjm_wqmis/views/DWSM/DwsmLocationScreen.dart';
import 'package:jjm_wqmis/views/DWSM/dwsmList/DemonstrationScreen.dart';
import 'package:jjm_wqmis/views/DWSM/dwsmList/SchoolAwcScreen.dart';
import 'package:jjm_wqmis/views/DWSM/tabschoolaganwadi/AnganwadiScreen.dart';
import 'package:jjm_wqmis/views/DWSM/tabschoolaganwadi/SchoolScreen.dart';
import 'package:jjm_wqmis/views/DWSM/tabschoolaganwadi/TabSchoolAganwadi.dart';
import 'package:jjm_wqmis/views/ExceptionScreen.dart';
import 'package:jjm_wqmis/views/auth/DashboardScreen.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/views/SampleListScreen.dart';
import 'package:jjm_wqmis/views/LocationScreen.dart';
import 'package:jjm_wqmis/views/auth/LoginScreen.dart';
import 'package:jjm_wqmis/views/SampleInformationScreen.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';
import 'package:jjm_wqmis/views/auth/SplashScreen.dart';
import 'package:jjm_wqmis/views/lab/AsPerLabView.dart';
import 'package:jjm_wqmis/views/lab/AsPerParameterView.dart';
import 'package:jjm_wqmis/views/lab/LabParameterScreen.dart';
import 'package:jjm_wqmis/views/lab/WtpLabScreen.dart';
import 'package:jjm_wqmis/views/webView/testReport.dart';
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
        ChangeNotifierProvider(create: (context) => DwsmProvider()),
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
        //auth
        AppConstants.navigateToDashboardScreen: (context) => Dashboardscreen(),
        AppConstants.navigateToLoginScreen: (context) => Loginscreen(),
        AppConstants.navigateToSplashScreen: (context) => SplashScreen(),

        //dwsmList
        AppConstants.navigateToDemonstrationScreen:(context) => Demonstrationscreen(type: 0),
        AppConstants.navigateToSchoolAwsScreen:(context) => SchoolAWCScreen(type: 0),
        //tabschoolaganwadi
        AppConstants.navigateToAnganwadiScreen: (context) => AnganwadiScreen(),
        AppConstants.navigateToSchoolScreen:(context)=>SchoolScreen(),
        AppConstants.navigateToTabSchoolAganwadi:(context) =>Tabschoolaganwadi(),
        //dwsm
        AppConstants.navigateToDwsmDashboard: (context) => Dwsdashboardscreen(),
        AppConstants.navigateToDwsmLocaitonScreen: (context) =>DwsmLocation(),
        //lab
        AppConstants.navigateLabView: (context) =>AsPerLabTabView(),
        AppConstants.navigateToParameterView: (context) =>Asperparameterview(),
        AppConstants.navigateToLabParam: (context) => Labparameterscreen(),
        AppConstants.navigateToWTPLab: (context) => Wtplabscreen(),

        //webview
        AppConstants.navigateToTestReport: (context) => TestReport(url: '',),

        AppConstants.navigateToExceptionScreen: (context) => ExceptionScreen(errorMessage: ''),
        AppConstants.navigateToLocationScreen: (context) => Locationscreen(flag: ''),
        AppConstants.navigateToSampleInformationScreen: (context) => Sampleinformationscreen(),
        AppConstants.navigateToSampleListScreen: (context) => SampleListScreen(),
        AppConstants.navigateToSubmitSampleScreen: (context) => SubmitSampleScreen(),

      },
    );
  }
}
