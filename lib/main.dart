import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ErrorProvider.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/providers/SampleListProvider.dart';
import 'package:jjm_wqmis/providers/SampleSubmitProvider.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/dashboardProvider.dart';
import 'package:jjm_wqmis/providers/dwsmProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/utils/AppRoutes.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await UserSessionManager().init();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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
      child: const MyApp(),
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
      routes: AppRoutes.getRoutes(),
    );
  }
}
