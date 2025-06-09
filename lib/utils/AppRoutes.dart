import 'package:flutter/cupertino.dart';

import 'package:jjm_wqmis/views/DWSM/DwsmDashboardScreen.dart';
import 'package:jjm_wqmis/views/DWSM/DwsmLocationScreen.dart';
import 'package:jjm_wqmis/views/DWSM/dwsmList/DemonstrationScreen.dart';
import 'package:jjm_wqmis/views/DWSM/dwsmList/SchoolAwcScreen.dart';
import 'package:jjm_wqmis/views/DWSM/tabschoolaganwadi/AnganwadiScreen.dart';
import 'package:jjm_wqmis/views/DWSM/tabschoolaganwadi/SchoolScreen.dart';
import 'package:jjm_wqmis/views/DWSM/tabschoolaganwadi/TabSchoolAganwadi.dart';
import 'package:jjm_wqmis/views/ExceptionScreen.dart';
import 'package:jjm_wqmis/views/LocationScreen.dart';
import 'package:jjm_wqmis/views/SampleInformationScreen.dart';
import 'package:jjm_wqmis/views/SampleListScreen.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';
import 'package:jjm_wqmis/views/auth/DashboardScreen.dart';
import 'package:jjm_wqmis/views/auth/LoginScreen.dart';
import 'package:jjm_wqmis/views/auth/SplashScreen.dart';
import 'package:jjm_wqmis/views/ftk/ftkDashboard.dart';
import 'package:jjm_wqmis/views/ftk/ftkSampleInformationScreen.dart';
import 'package:jjm_wqmis/views/ftk/ftkSampleScreen.dart';
import 'package:jjm_wqmis/views/lab/AsPerLabView.dart';
import 'package:jjm_wqmis/views/lab/AsPerParameterView.dart';
import 'package:jjm_wqmis/views/lab/LabParameterScreen.dart';
import 'package:jjm_wqmis/views/lab/WtpLabScreen.dart';
import 'package:jjm_wqmis/views/webView/testReport.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //auth
      AppConstants.navigateToDashboardScreen: (context) => const Dashboardscreen(),
      AppConstants.navigateToLoginScreen: (context) => const Loginscreen(),
      '/': (context) => const SplashScreen(),

      //dwsmList
      AppConstants.navigateToDemonstrationScreen: (context) =>
          const Demonstrationscreen(type: 0),
      AppConstants.navigateToSchoolAwsScreen: (context) =>
          const SchoolAWCScreen(type: 0),
      //tabschoolaganwadi
      AppConstants.navigateToAnganwadiScreen: (context) => const AnganwadiScreen(),
      AppConstants.navigateToSchoolScreen: (context) => const SchoolScreen(),
      AppConstants.navigateToTabSchoolAganwadi: (context) =>
          const Tabschoolaganwadi(),
      //dwsm
      AppConstants.navigateToDwsmDashboard: (context) => const Dwsdashboardscreen(),
      AppConstants.navigateToDwsmLocaitonScreen: (context) => const DwsmLocation(),
      //lab
      AppConstants.navigateLabView: (context) => const AsPerLabTabView(),
      AppConstants.navigateToParameterView: (context) => const Asperparameterview(),
      AppConstants.navigateToLabParam: (context) => const Labparameterscreen(),
      AppConstants.navigateToWTPLab: (context) => const Wtplabscreen(),


      //ftk
      AppConstants.navigateToFtkSampleScreen: (context) => const ftksamplescreen(),
      AppConstants.navigateToFtkDashboard: (context) => const ftkDashboard(),

      //webview
      AppConstants.navigateToTestReport: (context) => const TestReport(
            url: '',
          ),

      AppConstants.navigateToExceptionScreen: (context) =>
          const ExceptionScreen(errorMessage: ''),
      AppConstants.navigateToLocationScreen: (context) =>
           Locationscreen(flag: '',flagFloating: '',),
      AppConstants.navigateToSampleInformationScreen: (context) =>
          const Sampleinformationscreen(),
      AppConstants.navigateToSampleListScreen: (context) => const SampleListScreen(),
      AppConstants.navigateToSubmitSampleScreen: (context) =>
          const SubmitSampleScreen(),
      AppConstants.navigateToftkSampleInfoScreen: (context) => const ftkSampleInformationScreen(),
    };
  }
}
