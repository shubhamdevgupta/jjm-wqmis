import 'package:flutter/cupertino.dart';


import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/custom_screen/exception_screen.dart';
import 'package:jjm_wqmis/utils/webView/testReport.dart';
import 'package:jjm_wqmis/views/auth/login_screen.dart';
import 'package:jjm_wqmis/views/auth/splash_screen.dart';
import 'package:jjm_wqmis/views/dept_data/dept_dashboard_screen.dart';
import 'package:jjm_wqmis/views/dept_data/dept_offline/chosevillage.dart';
import 'package:jjm_wqmis/views/dept_data/sampleinfo/location_screen.dart';
import 'package:jjm_wqmis/views/dept_data/sampleinfo/sample_info_screen.dart';
import 'package:jjm_wqmis/views/dept_data/sample_list_screen.dart';
import 'package:jjm_wqmis/views/dept_data/submit_sample_screen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/lab_tab_screen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/parameter_tab_screen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/lab_param_screen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/wtp_lab_screen.dart';
import 'package:jjm_wqmis/views/dwsm_data/dwsm_dashboard_screen.dart';
import 'package:jjm_wqmis/views/dwsm_data/dwsm_location_screen.dart';
import 'package:jjm_wqmis/views/dwsm_data/dwsmList/demonstration_screen.dart';
import 'package:jjm_wqmis/views/dwsm_data/dwsmList/school_awc_screen.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/anganwadi_screen.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/school_screen.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/school_aganwadi_screen.dart';
import 'package:jjm_wqmis/views/ftk_data/ftk_dashboard.dart';
import 'package:jjm_wqmis/views/ftk_data/ftk_menu_dashboard_screen.dart';
import 'package:jjm_wqmis/views/ftk_data/ftk_sample_info_screen.dart';
import 'package:jjm_wqmis/views/ftk_data/ftk_sample_list_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //auth
      AppConstants.navigateToDashboardScreen: (context) => const Dashboardscreen(),
      AppConstants.navigateToLoginScreen: (context) => const Loginscreen(),
      AppConstants.navigateToSplashScreen: (context) => const SplashScreen(),

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
      AppConstants.navigateToFtkSampleListScreen:(context)=> const FtkSampleListScreen(),
      //webview
      AppConstants.navigateToTestReport: (context) => const TestReport(
            url: '',
          ),

      AppConstants.navigateToExceptionScreen: (context) =>
          const ExceptionScreen(errorMessage: '',errorCode: "",),
      AppConstants.navigateToLocationScreen: (context) =>
           const Locationscreen(flag: '',flagFloating: '',),
      AppConstants.navigateToChosevillage: (context) =>
           const Chosevillage(flag: '',flagFloating: '',),
      AppConstants.navigateToSampleInformationScreen: (context) =>
          const Sampleinformationscreen(),
      AppConstants.navigateToSampleListScreen: (context) => const SampleListScreen(),
      AppConstants.navigateToSubmitSampleScreen: (context) =>
          const SubmitSampleScreen(),
      AppConstants.navigateToftkSampleInfoScreen: (context) => const ftkSampleInformationScreen(),
    };
  }
}
