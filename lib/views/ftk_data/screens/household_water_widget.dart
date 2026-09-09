import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/providers/testing_date_time_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_textfield.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/ftk_data/fkt_submit_sample.dart';
import 'package:jjm_wqmis/views/ftk_data/screens/time_address_widget.dart';
import 'package:provider/provider.dart';

class HouseholdWaterWidget extends StatefulWidget {
  const HouseholdWaterWidget({super.key});

  @override
  State<HouseholdWaterWidget> createState() => _HouseholdWaterWidgetState();
}

class _HouseholdWaterWidgetState extends State<HouseholdWaterWidget> {
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
            WaterTestingSourceType.household,
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
                                    Column(
                                      children: [
                                        Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin: const EdgeInsets.all(5),
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Select Habitation *",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .black87, // Dark text for better readability
                                                  ),
                                                ),

                                                const Divider(
                                                  height: 10,
                                                  color: Colors.grey,
                                                  thickness: 1,
                                                ),
                                                const SizedBox(height: 4),
                                                // Space between title and dropdown
                                                CustomDropdown(
                                                  title: "",
                                                  value: masterProvider
                                                      .selectedHabitation,
                                                  showSearchBar: false,
                                                  items: masterProvider
                                                      .habitationId
                                                      .map((habitation) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: habitation
                                                          .habitationId
                                                          .toString(),
                                                      child: Text(
                                                        habitation
                                                            .habitationName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    masterProvider
                                                        .setSelectedHabitation(
                                                            value);
                                                  },
                                                  appBarTitle:
                                                      "Select Habitation",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (masterProvider.selectedHabitation !=
                                                null &&
                                            masterProvider.selectedHabitation !=
                                                "0")
                                          Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.all(5),
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Select Scheme *",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const Divider(
                                                    height: 10,
                                                    color: Colors.grey,
                                                    thickness: 1,
                                                  ),
                                                  CustomDropdown(
                                                    value: masterProvider
                                                        .selectedScheme,
                                                    showSearchBar: true,
                                                    items: masterProvider
                                                        .schemes
                                                        .map((scheme) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: scheme.schemeId
                                                            .toString(),
                                                        child: Text(
                                                          scheme.schemeName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      );
                                                    }).toList(),
                                                    title: "",
                                                    appBarTitle:
                                                        "Select Scheme",
                                                    onChanged: (value) {
                                                      masterProvider
                                                          .setSelectedScheme(
                                                              value);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: sourceId == "3" &&
                                              masterProvider.selectedScheme !=
                                                  null,
                                          child: Card(
                                            elevation: 5,
                                            // Increased elevation for a more modern shadow effect
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12), // Slightly increased border radius for a smooth look
                                            ),
                                            color: Colors.white,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              // Inner padding
                                              margin: const EdgeInsets.only(
                                                  top: 12),
                                              // Spacing from the first container
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 3,
                                                        groupValue: masterProvider
                                                            .selectedHousehold,
                                                        onChanged: (value) {
                                                          masterProvider
                                                              .householdController
                                                              .clear();
                                                          masterProvider
                                                              .selectRadioOption(
                                                                  value!);
                                                          testingProvider
                                                              .setSourceType(
                                                            WaterTestingSourceType
                                                                .household,
                                                          );
                                                        },
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          masterProvider
                                                              .householdController
                                                              .clear();
                                                          masterProvider
                                                              .selectRadioOption(
                                                                  3);
                                                        },
                                                        child: const Text(
                                                            'At household'),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 4,
                                                        groupValue: masterProvider
                                                            .selectedHousehold,
                                                        onChanged:
                                                            (value) async {
                                                          masterProvider
                                                              .selectRadioOption(
                                                                  value!);
                                                          testingProvider
                                                              .setSourceType(
                                                            WaterTestingSourceType
                                                                .anganwadi,
                                                          );
                                                        },
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          masterProvider
                                                              .householdController
                                                              .clear();
                                                          masterProvider
                                                              .selectRadioOption(
                                                                  4);
                                                          masterProvider
                                                              .setSelectedSubSource(
                                                                  2);
                                                          await masterProvider.fetchSourceInformation(
                                                              masterProvider
                                                                  .selectedVillage!,
                                                              "0",
                                                              masterProvider
                                                                  .selectedWtsfilter!,
                                                              masterProvider
                                                                  .selectedSubSource
                                                                  .toString(),
                                                              "0",
                                                              "0",
                                                              masterProvider
                                                                  .selectedStateId!,
                                                              masterProvider
                                                                  .selectedScheme!,
                                                              session.regId);
                                                        },
                                                        child: const Text(
                                                            'At school/AWCs'),
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
                                                  .selectedHousehold ==
                                              3,
                                          child: Card(
                                            elevation: 5,
                                            // Increased elevation for a more modern shadow effect
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12), // Slightly increased border radius for a smooth look
                                            ),
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                // Align text to the left
                                                children: [
                                                  CustomTextField(
                                                    labelText:
                                                        'Name of household *',
                                                    hintText: 'Enter Location',
                                                    prefixIcon:
                                                        Icons.cabin_rounded,
                                                    controller: masterProvider
                                                        .householdController,
                                                    isRequired: true,
                                                  ),
                                                  TimeAddressWidget(
                                                      masterProvider:
                                                          masterProvider),
                                                  const SizedBox(
                                                    height: 18,
                                                  ),
                                                  Center(
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (masterProvider
                                                              .validateHouseholdWaterFields()) {
                                                            masterProvider
                                                                    .otherSourceLocation =
                                                                masterProvider
                                                                    .householdController
                                                                    .text;
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
                                                                      )),
                                                            );
                                                          } else {
                                                            ToastHelper
                                                                .showToastMessage(
                                                                    masterProvider
                                                                        .errorMsg);
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
                                          ),
                                        ),
                                        Visibility(
                                          visible: masterProvider
                                                  .selectedHousehold ==
                                              4,
                                          child: Card(
                                            elevation: 5,
                                            // Increased elevation for a more modern shadow effect
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12), // Slightly increased border radius for a smooth look
                                            ),
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  masterProvider.baseStatus == 0
                                                      ? AppTextWidgets
                                                          .errorText(
                                                              masterProvider
                                                                  .errorMsg)
                                                      : CustomDropdown(
                                                          appBarTitle:
                                                              'Select School / AWCs',
                                                          title:
                                                              "Select School / AWCs *",
                                                          value: masterProvider
                                                                  .waterSource
                                                                  .any((item) =>
                                                                      item.locationId ==
                                                                      masterProvider
                                                                          .selectedWaterSource)
                                                              ? masterProvider
                                                                  .selectedWaterSource
                                                              : null,
                                                          // Ensure valid value
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
                                                                      .first,
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
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  if (masterProvider
                                                                      .validateHouseholdWaterFields()) {
                                                                    masterProvider
                                                                            .otherSourceLocation =
                                                                        masterProvider
                                                                            .householdController
                                                                            .text;
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ChangeNotifierProvider.value(
                                                                                value: masterProvider,
                                                                                child: const FtkParameterListScreen(),
                                                                              )),
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
                                        const SizedBox(
                                          height: 10,
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
