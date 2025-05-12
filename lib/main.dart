 import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jjm_wqmis/models/DashboardResponse/DwsmDashboardResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/BlockResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/HabitationResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
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
import 'package:jjm_wqmis/views/DWSM/tabschoolaganwadi/TabSchoolAganwadi.dart';
import 'package:jjm_wqmis/views/auth/DashboardScreen.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/views/SampleListScreen.dart';
import 'package:jjm_wqmis/views/LocationScreen.dart';
import 'package:jjm_wqmis/views/auth/LoginScreen.dart';
import 'package:jjm_wqmis/views/SampleInformationScreen.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';
import 'package:jjm_wqmis/views/auth/SplashScreen.dart';
import 'package:jjm_wqmis/views/lab/LabParameterScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  Hive.registerAdapter(StateresponseAdapter()); // use your response class
  Hive.registerAdapter(DistrictresponseAdapter());
  Hive.registerAdapter(BlockResponseAdapter());
  Hive.registerAdapter(GramPanchayatresponseAdapter());
  Hive.registerAdapter(VillageresponseAdapter());
  Hive.registerAdapter(HabitationResponseAdapter());

  await Hive.openBox('statesBox');
  await Hive.openBox('districtsBox');
  await Hive.openBox('blocksBox');
  await Hive.openBox('gpBox');
  await Hive.openBox('villagesBox');
  await Hive.openBox('habitationBox');
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
        // '/': (context) => SelectedTestNew(),
       '/': (context) => SplashScreen(),
        AppConstants.navigateToSaveSample: (context) => Sampleinformationscreen(),
        AppConstants.navigateToDashboard: (context) => Dashboardscreen(),
        AppConstants.navigateToLogin: (context) => Loginscreen(),
        AppConstants.navigateToLocation: (context) => Locationscreen(flag: "",),
        AppConstants.navigateToLabParam: (context) => Labparameterscreen(),
        AppConstants.navigateToTest: (context) => SubmitSampleScreen(),
        AppConstants.navigateToSampleList: (context) => SampleListScreen(),
        AppConstants.navigateToSubmit_info: (context) => Tabschoolaganwadi(),
        AppConstants.navigateToDwsmDashboard: (context) => Dwsdashboardscreen(),

      },
    );
  }
}
