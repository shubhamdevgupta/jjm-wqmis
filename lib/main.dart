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
import 'package:jjm_wqmis/utils/AppUtil.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_routes.dart';
import 'package:jjm_wqmis/utils/current_location.dart';
import 'package:jjm_wqmis/utils/encyp_decyp.dart';
import 'package:jjm_wqmis/utils/update_dialog.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppUtil.init();   // <-- Load version at startup

  await LocalStorageService.init();
  await Firebase.initializeApp();
  await AesEncryption.initKey();
  await CurrentLocation.init();

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
        ChangeNotifierProvider(create: (_) => UpdateViewModel()),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize updateViewModel reference (check happens in splash screen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        _updateViewModel = Provider.of<UpdateViewModel>(navigatorKey.currentContext!, listen: false);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only check on resume if 15 minutes have passed (throttled check)
    if (state == AppLifecycleState.resumed && _updateViewModel != null) {
      _checkForUpdate(forceCheck: false);
    }
  }

  /// Check for update with throttling support
  Future<void> _checkForUpdate({required bool forceCheck}) async {
    if (_updateViewModel == null) return;

    // Prevent duplicate dialogs
    if (_updateViewModel!.isDialogShown) return;

    // Use throttled check (unless forced on startup)
    final isAvailable = await _updateViewModel!.checkForUpdateWithThrottle(forceCheck: forceCheck);
    
    if (isAvailable && navigatorKey.currentContext != null && mounted) {
      final updateInfo = await _updateViewModel!.getUpdateInfo();
      if (updateInfo != null && !_updateViewModel!.isDialogShown) {
        _updateViewModel!.setDialogShown(true);
        await DialogUtils.showUpdateDialog(navigatorKey.currentContext!, updateInfo);
        _updateViewModel!.setDialogShown(false);
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
