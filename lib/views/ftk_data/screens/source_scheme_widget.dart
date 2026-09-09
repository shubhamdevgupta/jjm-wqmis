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

class SourceOfSchemeWidget extends StatefulWidget {
  const SourceOfSchemeWidget({
    super.key,
  });

  @override
  State<SourceOfSchemeWidget> createState() => _SourceOfSchemeWidgetState();
}

class _SourceOfSchemeWidgetState extends State<SourceOfSchemeWidget> {
  final session = UserSessionManager();

  String? sourceId; // 👈 Store the ID here
  String? sourceType;

  @override
  void initState() {
    print("==========$sourceId");
    print("==========$sourceType");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null && args is Map) {
        sourceId = args['sourceId']?.toString();
        sourceType = args['sourceType']?.toString();
      }
      await session.init();
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
                                    const SizedBox(height: 10,),

                                    Column(
                                      children: [
                                        Visibility(
                                          visible: sourceId == "2" &&
                                              (masterProvider.selectedScheme
                                                      ?.isNotEmpty ??
                                                  false),
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.all(5),
                                            color: Colors.white,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              // Inner padding
                                              margin: const EdgeInsets.only(
                                                  top: 12),
                                              // Spacing from the previous widget
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                // Align text to the left
                                                children: [
                                                  Text(
                                                    'Select Sub-Source Category:',
                                                    style: AppStyles
                                                        .textStyleBoldBlack16,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 1,
                                                        groupValue: masterProvider
                                                            .selectedSubSource,
                                                        onChanged: (value) {
                                                          masterProvider
                                                              .selectRadioOption(
                                                                  value!);
                                                          testingProvider
                                                              .setSourceType(
                                                            WaterTestingSourceType
                                                                .groundwater,
                                                          );
                                                        },
                                                      ),
                                                      const Text(
                                                        'Ground water sources (GW)',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'OpenSans'),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 2,
                                                        groupValue: masterProvider
                                                            .selectedSubSource,
                                                        onChanged: (value) {
                                                          masterProvider
                                                              .selectRadioOption(
                                                                  value!);
                                                          testingProvider
                                                              .setSourceType(
                                                            WaterTestingSourceType
                                                                .surfaceWater,
                                                          );
                                                        },
                                                      ),
                                                      const Text(
                                                        'Surface water sources (SW)',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'OpenSans'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: masterProvider
                                                      .selectedSubSource !=
                                                  null &&
                                              sourceId == "2",
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12), // Slightly increased border radius for a smooth look
                                            ),
                                            margin: const EdgeInsets.all(5),
                                            // Margin to ensure spacing around the card
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                // Align text to the left
                                                children: [
                                                  masterProvider.baseStatus == 0
                                                      ? AppTextWidgets
                                                          .errorText(
                                                              masterProvider
                                                                  .errorMsg)
                                                      : CustomDropdown(
                                                          title:
                                                              "Select Water Source *",
                                                          appBarTitle:
                                                              "Select Water Source",
                                                          value: masterProvider
                                                              .selectedWaterSource,
                                                          items: masterProvider
                                                              .waterSource
                                                              .map(
                                                                  (waterSource) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: waterSource
                                                                  .locationId,
                                                              child: Text(
                                                                waterSource
                                                                    .locationName,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            final selectedWaterSource =
                                                                masterProvider
                                                                    .waterSource
                                                                    .firstWhere(
                                                              (source) =>
                                                                  source
                                                                      .locationId ==
                                                                  value,
                                                              orElse: () =>
                                                                  masterProvider
                                                                      .waterSource
                                                                      .first, // Handle the case where no match is found (optional)
                                                            );
                                                            masterProvider
                                                                .setSelectedWaterSourceInformationName(
                                                                    selectedWaterSource
                                                                        .locationName);
                                                            masterProvider
                                                                .setSelectedWaterSourceInformation(
                                                                    value);
                                                          },
                                                        ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Visibility(
                                                      visible: masterProvider
                                                              .selectedWaterSource !=
                                                          "",
                                                      child: Column(
                                                        children: [
                                                          TimeAddressWidget(
                                                              masterProvider:
                                                                  masterProvider),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Center(
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              // Full width of the parent
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  if (masterProvider
                                                                      .validateSourceofScheme()) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                ChangeNotifierProvider.value(
                                                                          value:
                                                                              masterProvider,
                                                                          child:
                                                                              const FtkParameterListScreen(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ToastHelper.showToastMessage(
                                                                        masterProvider
                                                                            .errorMsg);
                                                                  }
                                                                },
                                                                style: AppStyles
                                                                    .buttonStylePrimary(),
                                                                child:
                                                                    const Text(
                                                                  'Next',
                                                                  style: AppStyles
                                                                      .textStyle,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
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
