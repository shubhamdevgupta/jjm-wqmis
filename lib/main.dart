import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/parameter_provider.dart';
import 'package:jjm_wqmis/providers/sample_list_provider.dart';
import 'package:jjm_wqmis/providers/sample_submit_provider.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/dashboard_provider.dart';
import 'package:jjm_wqmis/providers/dwsm_provider.dart';
import 'package:jjm_wqmis/providers/ftk_provider.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/providers/update_provider.dart';
import 'package:jjm_wqmis/services/local_storage_service.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_routes.dart';
import 'package:jjm_wqmis/utils/encyp_decyp.dart';
import 'package:jjm_wqmis/utils/update_dialog.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  await Firebase.initializeApp();
  await AesEncryption.initKey();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => Masterprovider()),
        ChangeNotifierProvider(create: (_) => ParameterProvider()),
        ChangeNotifierProvider(create: (_) => Samplesubprovider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => Samplelistprovider()),
        ChangeNotifierProvider(create: (_) => DwsmProvider()),
        ChangeNotifierProvider(create: (_) => Ftkprovider()),
        ChangeNotifierProvider(create: (_) => UpdateViewModel()), // ✅ Added
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  UpdateViewModel? _updateViewModel;
  bool _updateDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateViewModel = Provider.of<UpdateViewModel>(navigatorKey.currentContext!, listen: false);
      _startUpdateWatcher();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelPeriodicChecker();
    super.dispose();
  }
  Timer? _periodicTimer;
  void _startUpdateWatcher() {
    _periodicTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _checkForUpdate();
    });
  }

  void _cancelPeriodicChecker() {
    _periodicTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_updateDialogShown) {
      _checkForUpdate();
    }
  }

  Future<void> _checkForUpdate() async {
    if (_updateViewModel == null || _updateDialogShown) return;

    bool isAvailable = await _updateViewModel!.checkForUpdate();
    if (isAvailable && navigatorKey.currentContext != null) {
      final updateInfo = await _updateViewModel!.getUpdateInfo();
      if (updateInfo != null) {
        _updateDialogShown = true;
        await DialogUtils.showUpdateDialog(navigatorKey.currentContext!, updateInfo);
        _updateDialogShown = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'JJM - WQMIS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppConstants.navigateToSplashScreen,
      routes: AppRoutes.getRoutes(),
    );
  }
}
