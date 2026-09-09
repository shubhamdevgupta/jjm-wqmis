import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/providers/testing_date_time_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/ftk_data/fkt_submit_sample.dart';
import 'package:jjm_wqmis/views/ftk_data/screens/scheme_dropdown_widget.dart';
import 'package:jjm_wqmis/views/ftk_data/screens/time_address_widget.dart';
import 'package:provider/provider.dart';

class EsrWaterWidget extends StatefulWidget {
  const EsrWaterWidget({
    super.key,
  });

  @override
  State<EsrWaterWidget> createState() => _EsrWaterWidgetState();
}

class _EsrWaterWidgetState extends State<EsrWaterWidget> {
  final session = UserSessionManager();

  String? sourceId; // 👈 Store the ID here
  String? sourceType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null && args is Map) {
        sourceId = args['sourceId']?.toString();
        sourceType = args['sourceType']?.toString();
      }
      session.init();

      context.read<TestingDateTimeProvider>().setSourceType(
            WaterTestingSourceType.storage,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final testingProvider = context.read<TestingDateTimeProvider>();
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          // Navigate back to Dashboard when pressing back button
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppConstants.navigateToFtkSampleScreen,
            (route) => false, // Clears all previous routes
          );
          return false; // Prevents default back action
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/header_bg.png'),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 5,
                centerTitle: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8),
                    right: Radius.circular(8),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, AppConstants.navigateToDashboardScreen);
                    }
                  },
                ),
                title: Text(
                  'FTK Collection form',
                  style: AppStyles.appBarTitle,
                ),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF096DA8), // Dark blue color
                        Color(0xFF3C8DBC), // jjm blue color
                      ],
                      begin: Alignment.topCenter, // Start at the top center
                      end: Alignment.bottomCenter, // End at the bottom center
                    ),
                  ),
                ),
              ),
              body: Consumer<Masterprovider>(
                  builder: (context, masterProvider, child) {
                return masterProvider.isLoading
                    ? LoaderUtils.conditionalLoader(
                        isLoading: masterProvider.isLoading)
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                      child: Text(
                                        sourceType ?? 'N/A',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'OpenSans',
                                          letterSpacing: 0.3,
                                          color: Color(0xFF1A1A1A),
                                          height: 1.2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Divider(
                                        thickness: 1, color: Colors.white60),

                                    /// SCHEME ONLY FOR NON HOUSEHOLD
                                    if (sourceId != "3")
                                      SchemeDropdownWidget(
                                        masterProvider: masterProvider,
                                        sourceId: sourceId,
                                        regId: session.regId,
                                      ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: const EdgeInsets.all(5),
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            masterProvider.baseStatus == 0
                                                ? AppTextWidgets.errorText(
                                                    masterProvider.errorMsg,
                                                  )
                                                : CustomDropdown(
                                                    title: "Select ESR/GSR *",
                                                    value: masterProvider
                                                        .selectedWaterSource,
                                                    items: masterProvider
                                                        .waterSource
                                                        .map((waterSource) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: waterSource
                                                            .locationId,
                                                        child: Text(
                                                          waterSource
                                                              .locationName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      masterProvider
                                                          .setSelectedWaterSourceInformation(
                                                              value);
                                                    },
                                                  ),
                                            const SizedBox(height: 10),
                                            Visibility(
                                              visible: masterProvider
                                                      .selectedWaterSource !=
                                                  "",
                                              child: Column(
                                                children: [
                                                  TimeAddressWidget(
                                                    masterProvider:
                                                        masterProvider,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Center(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (masterProvider
                                                              .validateEsrWaterFields()) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ChangeNotifierProvider
                                                                        .value(
                                                                  value:
                                                                      masterProvider,
                                                                  child:
                                                                      const FtkParameterListScreen(),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            ToastHelper
                                                                .showToastMessage(
                                                              masterProvider
                                                                  .errorMsg,
                                                            );
                                                          }
                                                        },
                                                        style: AppStyles
                                                            .buttonStylePrimary(),
                                                        child: const Text(
                                                          'Next',
                                                          style: AppStyles
                                                              .textStyle,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              })),
        ),
      ),
    );
  }
}
