import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/views/dept_data/SampleListScreen.dart';
import 'package:jjm_wqmis/views/dept_data/SubmitSampleScreen.dart';
import 'package:jjm_wqmis/views/dept_data/auth/DashboardScreen.dart';
import 'package:jjm_wqmis/views/dept_data/auth/LoginScreen.dart';
import 'package:jjm_wqmis/views/dept_data/auth/SplashScreen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/AsPerLabView.dart';
import 'package:jjm_wqmis/views/dept_data/lab/AsPerParameterView.dart';
import 'package:jjm_wqmis/views/dept_data/lab/LabParameterScreen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/WtpLabScreen.dart';

import 'package:jjm_wqmis/views/dwsm_data/DwsmDashboardScreen.dart';
import 'package:jjm_wqmis/utils/custom_screen/ExceptionScreen.dart';
import 'package:jjm_wqmis/views/dept_data/LocationScreen.dart';
import 'package:jjm_wqmis/views/dept_data/SampleInformationScreen.dart';
import 'package:jjm_wqmis/views/dwsm_data/DwsmLocationScreen.dart';
import 'package:jjm_wqmis/views/dwsm_data/dwsmList/DemonstrationScreen.dart';
import 'package:jjm_wqmis/views/dwsm_data/dwsmList/SchoolAwcScreen.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/AnganwadiScreen.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/SchoolScreen.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/TabSchoolAganwadi.dart';
import 'package:jjm_wqmis/views/ftk_data/ftkDashboard.dart';
import 'package:jjm_wqmis/views/ftk_data/ftkMenuDashboardScreen.dart';
import 'package:jjm_wqmis/views/ftk_data/ftkSampleInformationScreen.dart';
import 'package:jjm_wqmis/views/ftk_data/ftkSampleListScreen.dart';
import 'package:jjm_wqmis/utils/custom_screen/testReport.dart';
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
      AppConstants.navigateToFtkSampleScreen: (context) => const Ftkmenudashboardscreen(),
      AppConstants.navigateToFtkDashboard: (context) => const ftkDashboard(),
      AppConstants.navigateToFtkSampleListScreen:(context)=> const ftkSampleListScreen(),
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
