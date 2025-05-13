import 'package:flutter/cupertino.dart';

import '../views/DWSM/DwsmDashboardScreen.dart';
import '../views/DWSM/DwsmLocationScreen.dart';
import '../views/DWSM/dwsmList/DemonstrationScreen.dart';
import '../views/DWSM/dwsmList/SchoolAwcScreen.dart';
import '../views/DWSM/tabschoolaganwadi/AnganwadiScreen.dart';
import '../views/DWSM/tabschoolaganwadi/SchoolScreen.dart';
import '../views/DWSM/tabschoolaganwadi/TabSchoolAganwadi.dart';
import '../views/ExceptionScreen.dart';
import '../views/LocationScreen.dart';
import '../views/SampleInformationScreen.dart';
import '../views/SampleListScreen.dart';
import '../views/SubmitSampleScreen.dart';
import '../views/auth/DashboardScreen.dart';
import '../views/auth/LoginScreen.dart';
import '../views/auth/SplashScreen.dart';
import '../views/lab/AsPerLabView.dart';
import '../views/lab/AsPerParameterView.dart';
import '../views/lab/LabParameterScreen.dart';
import '../views/lab/WtpLabScreen.dart';
import '../views/webView/testReport.dart';
import 'AppConstants.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //auth
      AppConstants.navigateToDashboardScreen: (context) => Dashboardscreen(),
      AppConstants.navigateToLoginScreen: (context) => Loginscreen(),
      '/': (context) => SplashScreen(),

      //dwsmList
      AppConstants.navigateToDemonstrationScreen: (context) =>
          Demonstrationscreen(type: 0),
      AppConstants.navigateToSchoolAwsScreen: (context) =>
          SchoolAWCScreen(type: 0),
      //tabschoolaganwadi
      AppConstants.navigateToAnganwadiScreen: (context) => AnganwadiScreen(),
      AppConstants.navigateToSchoolScreen: (context) => SchoolScreen(),
      AppConstants.navigateToTabSchoolAganwadi: (context) =>
          Tabschoolaganwadi(),
      //dwsm
      AppConstants.navigateToDwsmDashboard: (context) => Dwsdashboardscreen(),
      AppConstants.navigateToDwsmLocaitonScreen: (context) => DwsmLocation(),
      //lab
      AppConstants.navigateLabView: (context) => AsPerLabTabView(),
      AppConstants.navigateToParameterView: (context) => Asperparameterview(),
      AppConstants.navigateToLabParam: (context) => Labparameterscreen(),
      AppConstants.navigateToWTPLab: (context) => Wtplabscreen(),

      //webview
      AppConstants.navigateToTestReport: (context) => TestReport(
            url: '',
          ),

      AppConstants.navigateToExceptionScreen: (context) =>
          ExceptionScreen(errorMessage: ''),
      AppConstants.navigateToLocationScreen: (context) =>
          Locationscreen(flag: ''),
      AppConstants.navigateToSampleInformationScreen: (context) =>
          Sampleinformationscreen(),
      AppConstants.navigateToSampleListScreen: (context) => SampleListScreen(),
      AppConstants.navigateToSubmitSampleScreen: (context) =>
          SubmitSampleScreen(),
    };
  }
}
