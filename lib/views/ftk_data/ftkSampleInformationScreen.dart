// Flutter layout for the 'Sample Information' form
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';
import 'package:jjm_wqmis/utils/custom_screen/CustomDateTimePicker.dart';

import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/Showerrormsg.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/utils/custom_screen/CustomDropdown.dart';
import 'package:jjm_wqmis/utils/custom_screen/CustomTextField.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/ftk_data/fktSubmitSample.dart';
import 'package:provider/provider.dart';

class ftkSampleInformationScreen extends StatefulWidget {
  const ftkSampleInformationScreen({super.key});

  @override
  _ftkSampleinformationscreen createState() => _ftkSampleinformationscreen();
}

class _ftkSampleinformationscreen extends State<ftkSampleInformationScreen> {
  final session = UserSessionManager();

  String? sourceId; // 👈 Store the ID here
  String? sourceType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.init();
      final masterProvider =
          Provider.of<Masterprovider>(context, listen: false);
      masterProvider.setSelectedVillageOnly(session.villageId.toString());
      masterProvider.setSelectedStateOnly(session.stateId.toString());
      masterProvider.setSelectedHabitation('0');
    await  masterProvider.fetchHabitations(
          session.stateId.toString(),
          session.districtId.toString(),
          session.blockId.toString(),
          session.panchayatId.toString(),
          session.villageId.toString());

      await masterProvider.fetchSchemes(
          session.stateId.toString(),
          session.districtId.toString(),
          session.villageId.toString(),
          masterProvider.selectedHabitation!,
          sourceId.toString());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map) {
      sourceId = args['sourceId'];
      sourceType = args['sourceType'];

      debugPrint("sourceId: $sourceId");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  'Ftk Collection form',
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
                              //card for state district selection
                              buildSampleTaken(masterProvider),

                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      );
              })),
        ),
      ),
    );
  }

  Widget buildSchemeDropDown(Masterprovider masterProvider) {
    return masterProvider.baseStatus == 0 &&
            masterProvider.selectedScheme == null
        ? AppTextWidgets.errorText(masterProvider.errorMsg)
        : Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(left: 5,right: 5),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Scheme",
                    style: TextStyle(
                      fontSize: 16, fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Dark text for better readability
                    ),
                  ),

                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 4), // Space between title and dropdown
                  CustomDropdown(
                    value: masterProvider.selectedScheme,
                    items: masterProvider.schemes.map((scheme) {
                      return DropdownMenuItem<String>(
                        value: scheme.schemeId.toString(),
                        child: Text(
                          scheme.schemeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      );
                    }).toList(),
                    title: "",
                    appBarTitle: "Select Scheme",
                    showSearchBar: true,
                    onChanged: (value) {

                      masterProvider.clearSelection();

                      masterProvider.setSelectedScheme(value);
                      if (sourceId == "5") {
                        masterProvider.fetchWTPList(
                          masterProvider.selectedStateId!,
                          value!, // <-- use directly here
                        );
                      } else if (sourceId == "6") {
                        masterProvider.setSelectedSubSource(0);
                        masterProvider.setSelectedWTP("0");
                        masterProvider.fetchSourceInformation(
                          masterProvider.selectedVillage!,
                          masterProvider.selectedHabitation!,
                          sourceId.toString(),
                          "0",
                          masterProvider.selectedSubSource.toString(),
                          masterProvider.selectedWtp!,
                          masterProvider.selectedStateId!,
                          masterProvider.selectedScheme!,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          );
  }

  Widget buildSampleTaken(Masterprovider masterProvider) {
    return Padding(
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
          const Divider(thickness: 1, color: Colors.white60),
          buildSchemeDropDown(masterProvider),
          buildSourceofScheme(masterProvider),
          buildEsrWater(masterProvider),
          buildHouseholdWater(masterProvider),
          buildHandpumpWater(masterProvider),
        ],
      ),
    );
  }

  Widget buildSourceofScheme(Masterprovider masterProvider) {
    return Column(
      children: [
        Visibility(
          visible: sourceId == "2" &&
              (masterProvider.selectedScheme?.isNotEmpty ?? false),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(10),
              // Inner padding
              margin: const EdgeInsets.only(top: 12),
              // Spacing from the previous widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  Text(
                    'Select Sub-Source Category:',
                    style: AppStyles.textStyleBoldBlack16,
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          masterProvider.selectRadioOption(1);
                        },
                        child: const Text(
                          'Ground water sources (GW)',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'OpenSans'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                          onTap: () {
                            masterProvider.selectRadioOption(2);
                          },
                          child: const Text(
                            'Surface water sources (SW)',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'OpenSans'),
                          )),
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
          visible: masterProvider.selectedSubSource != null && sourceId == "2",
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  masterProvider.baseStatus == 0
                      ? AppTextWidgets.errorText(masterProvider.errorMsg)
                      : CustomDropdown(
                          title: "Select Water Source *",appBarTitle: "Select Water Source",
                          value: masterProvider.selectedWaterSource,
                          items: masterProvider.waterSource.map((waterSource) {
                            return DropdownMenuItem<String>(
                              value: waterSource.locationId,
                              child: Text(
                                waterSource.locationName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            final selectedWaterSource = masterProvider.waterSource.firstWhere(
                              (source) => source.locationId == value,
                              orElse: () => masterProvider.waterSource
                                  .first, // Handle the case where no match is found (optional)
                            );
                            masterProvider
                                .setSelectedWaterSourceInformationName(
                                    selectedWaterSource.locationName);
                            masterProvider
                                .setSelectedWaterSourceInformation(value);
                          },
                        ),
                  const SizedBox(
                    height: 10,
                  ),



                  Visibility(
                      visible: masterProvider.selectedWaterSource != "",
                      child: Column(
                        children: [
                          buildTimeAddressRemarks(masterProvider),

                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: SizedBox(
                              width: double.infinity, // Full width of the parent
                              child: ElevatedButton(
                                onPressed: () {
                                  if (validateSourceofScheme(masterProvider)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider.value(
                                              value: masterProvider,
                                              child: const FtkParameterListScreen(),
                                            ),
                                      ),
                                    );
                                  } else {
                                    ToastHelper.showToastMessage(
                                        masterProvider.errorMsg);
                                  }
                                },
                                style: AppStyles.buttonStylePrimary(),
                                child: const Text(
                                  'Next',
                                  style: AppStyles.textStyle,
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
    );
  }

  Widget buildEsrWater(Masterprovider masterProvider) {
    return Visibility(
        visible: sourceId == "6" &&
            (masterProvider.selectedScheme?.isNotEmpty ?? false),
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                masterProvider.baseStatus == 0
                    ? AppTextWidgets.errorText(masterProvider.errorMsg)
                    : CustomDropdown(
                        title: "Select ESR/GSR *",
                        value: masterProvider.selectedWaterSource,
                        items: masterProvider.waterSource.map((waterSource) {
                          return DropdownMenuItem<String>(
                            value: waterSource.locationId,
                            child: Text(
                              waterSource.locationName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          masterProvider
                              .setSelectedWaterSourceInformation(value);
                        },
                      ),
                const SizedBox(
                  height: 10,
                ),




                Visibility(
                    visible: masterProvider.selectedWaterSource != "",
                    child: Column(
                      children: [
                        buildTimeAddressRemarks(masterProvider),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (validateEsrWaterFields(masterProvider)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider.value(
                                              value: masterProvider,
                                              child: const FtkParameterListScreen(),
                                            )),
                                  );
                                } else {
                                  ToastHelper.showToastMessage(masterProvider.errorMsg);
                                }
                              },
                              style: AppStyles.buttonStylePrimary(),
                              child: const Text(
                                'Next',
                                style: AppStyles.textStyle,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),

              ],
            ),
          ),
        ));
  }

  Widget buildHouseholdWater(Masterprovider masterProvider) {
    return Visibility(
      visible: sourceId == "3" &&
          (masterProvider.selectedScheme?.isNotEmpty ?? false),
      child: Column(
        children: [
          Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Slightly increased border radius for a smooth look
            ),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(10),
              // Inner padding
              margin: const EdgeInsets.only(top: 12),
              // Spacing from the first container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 3,
                        groupValue: masterProvider.selectedHousehold,
                        onChanged: (value) {
                          masterProvider.householdController.clear();
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          masterProvider.householdController.clear();
                          masterProvider.selectRadioOption(3);
                        },
                        child: const Text('At household'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 4,
                        groupValue: masterProvider.selectedHousehold,
                        onChanged: (value) async {
                          masterProvider.householdController.clear();
                          masterProvider.setSelectedHabitation("0");
                          masterProvider.selectRadioOption(value!);
                          masterProvider.setSelectedHouseHold(value);
                          masterProvider.setSelectedSubSource(2);
                          await masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              "0",
                              masterProvider.selectedWtsfilter!,
                              masterProvider.selectedSubSource.toString(),
                              "0",
                              "0",
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!);
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          masterProvider.householdController.clear();
                          masterProvider.setSelectedHabitation("0");
                          masterProvider.setSelectedSubSource(2);
                          await masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              "0",
                              masterProvider.selectedWtsfilter!,
                              masterProvider.selectedSubSource.toString(),
                              "0",
                              "0",
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!);
                        },
                        child: const Text('At school/AWCs'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: masterProvider.selectedHousehold == 3,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(5),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Habitation *",
                      style: TextStyle(
                        fontSize: 16, fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.black87, // Dark text for better readability
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
                      value: masterProvider.selectedHabitation,
                      showSearchBar: false,
                      items: masterProvider.habitationId.map((habitation) {
                        return DropdownMenuItem<String>(
                          value: habitation.habitationId.toString(),
                          child: Text(
                            habitation.habitationName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        masterProvider.setSelectedHabitation(value);
                      },
                      appBarTitle: "Select Habitation",
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
            visible: masterProvider.selectedHousehold == 3 &&
                masterProvider.selectedHabitation != null &&
                masterProvider.selectedHabitation != "0",
            child: Card(
              elevation: 5,
              // Increased elevation for a more modern shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    12), // Slightly increased border radius for a smooth look
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align text to the left
                  children: [
                    CustomTextField(
                      labelText: 'Name of household *',
                      hintText: 'Enter Location',
                      prefixIcon: Icons.cabin_rounded,
                      controller: masterProvider.householdController,
                      isRequired: true,
                    ),
                    buildTimeAddressRemarks(masterProvider),
                    const SizedBox(
                      height: 18,
                    ),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (validateHouseholdWaterFields(masterProvider,
                                masterProvider.householdController)) {
                              masterProvider.otherSourceLocation =
                                  masterProvider.householdController.text;
                              Navigator.push(
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
                                  masterProvider.errorMsg);
                            }
                          },
                          style: AppStyles.buttonStylePrimary(),
                          child: const Text(
                            'Next',
                            style: AppStyles.textStyle,
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
            visible: masterProvider.selectedHousehold == 4,
            child: Card(
              elevation: 5,
              // Increased elevation for a more modern shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    12), // Slightly increased border radius for a smooth look
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    masterProvider.baseStatus == 0
                        ? AppTextWidgets.errorText(masterProvider.errorMsg)
                        : CustomDropdown(
                            appBarTitle: 'Select School / AWCs',
                            title: "Select School / AWCs *",
                            value: masterProvider.waterSource.any((item) => item.locationId == masterProvider.selectedWaterSource) ? masterProvider.selectedWaterSource : null,
                            // Ensure valid value
                            items: masterProvider.waterSource.map((waterSource) {
                              return DropdownMenuItem<String>(
                                value: waterSource.locationId,
                                child: Text(
                                  waterSource.locationName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              final selectedWaterSource =
                                  masterProvider.waterSource.firstWhere(
                                (source) => source.locationId == value,
                                orElse: () => masterProvider.waterSource
                                    .first,
                              );
                              masterProvider
                                  .setSelectedWaterSourceInformationName(
                                      selectedWaterSource.locationName);
                              masterProvider
                                  .setSelectedWaterSourceInformation(value);
                            },
                          ),
                    Visibility(
                         visible: masterProvider.selectedWaterSource != "",
                        child: Column(
                          children: [
                            buildTimeAddressRemarks(masterProvider),

                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (validateHouseholdWaterFields(masterProvider,
                                        masterProvider.householdController)) {
                                      masterProvider.otherSourceLocation =
                                          masterProvider.householdController.text;
                                      Navigator.push(
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
                                          masterProvider.errorMsg);
                                    }
                                  },
                                  style: AppStyles.buttonStylePrimary(),
                                  child: const Text(
                                    'Next',
                                    style: AppStyles.textStyle,
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
      ),
    );
  }

  Widget buildHandpumpWater(Masterprovider masterProvider) {
    return Column(
      children: [
        Visibility(
          visible: sourceId == "4" &&
              (masterProvider.selectedScheme?.isNotEmpty ?? false),
          child: Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(10),
              // Inner padding
              margin: const EdgeInsets.only(top: 12),
              // Spacing from the first container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 7,
                        groupValue: masterProvider.selectedHandpumpPrivate,
                        onChanged: (value) {
                          masterProvider.setSelectedHabitation("0");
                          masterProvider.cleartxt();
                          masterProvider.selectRadioOption(value!);
                          print('----${masterProvider.selectedWaterSourceName}');
                        },
                      ),
                      InkWell(
                          onTap: () {
                            masterProvider.cleartxt();
                            masterProvider.selectRadioOption(7);
                          },
                          child: const Text('Govt. Handpump')),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 8,
                        groupValue: masterProvider.selectedHandpumpPrivate,
                        onChanged: (value) {
                          masterProvider.cleartxt(); // if you want to clear text fields too

                          masterProvider.selectRadioOption(value!);
                          print(
                              '----${masterProvider.selectedWaterSourceName}');
                        },
                      ),
                      InkWell(
                        onTap: () {
                          masterProvider.cleartxt(); // if needed
                          masterProvider.selectRadioOption(8);
                        },
                        child: const Text('Private source location'),
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
          visible: masterProvider.selectedHandpumpPrivate == 8,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Habitation *",
                    style: TextStyle(
                      fontSize: 16, fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color:
                      Colors.black87, // Dark text for better readability
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
                    value: masterProvider.selectedHabitation,
                    showSearchBar: true,
                    items: masterProvider.habitationId.map((habitation) {
                      return DropdownMenuItem<String>(
                        value: habitation.habitationId.toString(),
                        child: Text(
                          habitation.habitationName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      masterProvider.setSelectedHabitation(value);
                    },
                    appBarTitle: "Select Habitation",
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
          visible:
              masterProvider.selectedHandpumpPrivate == 7 && sourceId == "4",
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  masterProvider.baseStatus == 0
                      ? AppTextWidgets.errorText(masterProvider.errorMsg)
                      : CustomDropdown(
                          title: "Select Govt. Handpump *",
                          appBarTitle: "Govt Handpump",
                          value: masterProvider.waterSource.any((item) =>
                                  item.locationId ==
                                  masterProvider.selectedWaterSource)
                              ? masterProvider.selectedWaterSource
                              : null,
                          items: masterProvider.waterSource.map((waterSource) {
                            return DropdownMenuItem<String>(
                              value: waterSource.locationId,
                              child: Text(
                                waterSource.locationName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            final selectedWaterSource =
                                masterProvider.waterSource.firstWhere(
                              (source) => source.locationId == value,
                              orElse: () => masterProvider.waterSource.first,
                            );
                            masterProvider.setSelectedWaterSourceInformationName(selectedWaterSource.locationName);
                            masterProvider.setSelectedWaterSourceInformation(value);
                          },
                        ),
                  Visibility(
                      visible: masterProvider.selectedWaterSource != "",
                      child: Column(
                        children: [
                          buildTimeAddressRemarks(masterProvider),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (validateHandpumpWaterFields(
                                      masterProvider,
                                      masterProvider.handpumpSourceController,
                                      masterProvider.handpumpLocationController)) {
                                    masterProvider.sampleTypeOther =
                                        masterProvider.handpumpSourceController.text;
                                    masterProvider.otherSourceLocation =
                                        masterProvider.handpumpLocationController.text;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                                value: masterProvider,
                                                child: const FtkParameterListScreen(),
                                              )),
                                    );
                                  } else {
                                    ToastHelper.showToastMessage(masterProvider.errorMsg);
                                  }
                                },
                                style: AppStyles.buttonStylePrimary(),
                                child: const Text(
                                  'Next',
                                  style: AppStyles.textStyle,
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
        Visibility(
          visible:
              masterProvider.selectedHandpumpPrivate == 8 && sourceId == "4" && masterProvider.selectedHabitation != null &&
                  masterProvider.selectedHabitation != "0",
          child: Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Slightly increased border radius for a smooth look
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    labelText: 'Type of source *',
                    hintText: 'Enter Source type',
                    prefixIcon: Icons.edit_calendar_sharp,
                    controller: masterProvider.handpumpSourceController,
                    isRequired: true,
                  ),
                  CustomTextField(
                    labelText: 'Enter Location *',
                    hintText: 'Enter Location',
                    prefixIcon: Icons.dehaze,
                    controller: masterProvider.handpumpLocationController,
                    isRequired: true,
                  ),
                  buildTimeAddressRemarks(masterProvider),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (validateHandpumpWaterFields(
                              masterProvider,
                              masterProvider.handpumpSourceController,
                              masterProvider.handpumpLocationController)) {
                            masterProvider.sampleTypeOther =
                                masterProvider.handpumpSourceController.text;
                            masterProvider.otherSourceLocation =
                                masterProvider.handpumpLocationController.text;
                            masterProvider.setSelectedWaterSourceInformation("0");
                            masterProvider.setSelectedWaterSourceInformationName(" ");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                        value: masterProvider,
                                        child: const FtkParameterListScreen(),
                                      )),
                            );
                          } else {
                            ToastHelper.showToastMessage(masterProvider.errorMsg);
                          }
                        },
                        style: AppStyles.buttonStylePrimary(),
                        child: const Text(
                          'Next',
                          style: AppStyles.textStyle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool validateSourceofScheme(Masterprovider masterProvider) {
    if (masterProvider.selectedScheme == null ||
        masterProvider.selectedScheme!.isEmpty) {
      masterProvider.errorMsg = "Scheme is empty or invalid.";
      return false;
    }

    if (masterProvider.selectedWaterSource == "" ||
        masterProvider.selectedWaterSource!.isEmpty) {
      masterProvider.errorMsg = "Water Source is empty or invalid";
      return false;
    }

    if (masterProvider.selectedDatetime == null) {
      masterProvider.errorMsg = "Sample Collection Date empty or invalid";
      return false;
    }
    return true;
  }

  bool validateWtpWaterFields(Masterprovider masterProvider) {
    if (masterProvider.selectedScheme == null ||
        masterProvider.selectedScheme!.isEmpty) {
      masterProvider.errorMsg = "Scheme is empty or invalid.";
      return false;
    }

    if (masterProvider.selectedWtp == null ||
        masterProvider.selectedWtp!.isEmpty) {
      masterProvider.errorMsg =
          "Water Treatment Plant (WTP) is empty or invalid";
      return false;
    }

    // Only validate water source if "Inlet of WTP" is selected
    if (masterProvider.selectedSubSource == 5 &&
        (masterProvider.selectedWaterSource == null ||
            masterProvider.selectedWaterSource!.isEmpty)) {
      masterProvider.errorMsg = "Water Source for Inlet is empty or invalid";
      return false;
    }

    if (masterProvider.selectedDatetime == null) {
      masterProvider.errorMsg = "Sample Collection Date empty or invalid";
      return false;
    }
    return true;
  }

  bool validateEsrWaterFields(Masterprovider masterProvider) {
    if (masterProvider.selectedScheme == null ||
        masterProvider.selectedScheme!.isEmpty) {
      masterProvider.errorMsg = "Scheme is empty or invalid.";
      return false;
    }

    if (masterProvider.selectedWaterSource == null ||
        masterProvider.selectedWaterSource!.isEmpty) {
      masterProvider.errorMsg = "ESR/GSR is empty or invalid.";
      return false;
    }

    if (masterProvider.selectedDatetime == null) {
      masterProvider.errorMsg = "Date and time is empty or invalid.";
      return false;
    }
    return true;
  }

  bool validateHouseholdWaterFields(Masterprovider masterProvider,
      TextEditingController householdController) {
    if (masterProvider.selectedScheme == '' ||
        masterProvider.selectedScheme!.isEmpty) {
      masterProvider.errorMsg = "Scheme is empty or invalid.";
      return false;
    }

    if (masterProvider.selectedHousehold == null) {
      masterProvider.errorMsg = "Household selection is empty or invalid.";
      return false;
    }

    if (masterProvider.selectedHousehold == 3) {
      if (householdController.text.trim().isEmpty) {
        masterProvider.errorMsg = "Household name is empty or invalid.";
        return false;
      }
    }

    if (masterProvider.selectedHousehold == 4) {
      if (masterProvider.selectedWaterSource == null ||
          masterProvider.selectedWaterSource!.isEmpty) {
        masterProvider.errorMsg = "School / AWC is empty or invalid.";
        return false;
      }
    }

    if (masterProvider.selectedDatetime == null) {
      masterProvider.errorMsg = "Date and time is empty or invalid.";
      return false;
    }

    return true;
  }

  bool validateHandpumpWaterFields(
      Masterprovider masterProvider,
      TextEditingController handpumpSourceController,
      TextEditingController handpumpLocationController) {
    if (masterProvider.selectedScheme == null ||
        masterProvider.selectedScheme!.isEmpty) {
      masterProvider.errorMsg = "Scheme is empty or invalid.";
      return false;
    }

    if (masterProvider.selectedHandpumpPrivate == null) {
      masterProvider.errorMsg = "Handpump type selection is empty or invalid.";
      return false;
    }

    if (masterProvider.selectedHandpumpPrivate == 7) {
      if (masterProvider.selectedWaterSource == null ||
          masterProvider.selectedWaterSource!.isEmpty) {
        masterProvider.errorMsg = "Govt. handpump is empty or invalid.";
        return false;
      }
    }

    if (masterProvider.selectedHandpumpPrivate == 8) {
      if (handpumpSourceController.text.trim().isEmpty) {
        masterProvider.errorMsg = "Type of source is empty or invalid.";
        return false;
      }
      if (handpumpLocationController.text.trim().isEmpty) {
        masterProvider.errorMsg = "Location is empty or invalid.";
        return false;
      }
    }

    if (masterProvider.selectedDatetime == null) {
      masterProvider.errorMsg = "Date and time is empty or invalid.";
      return false;
    }

    return true;
  }

  Widget buildTimeAddressRemarks(Masterprovider masterProvider) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align text to the left
          children: [
            CustomDateTimePicker(
              onDateTimeSelected: (value) {
                masterProvider.setSelectedDateTime(value);
              },
              textTitle: "Date & Time of Sample Collection *",
            ),
            const SizedBox(
              height: 10,
            ),
            CustomDateTimePicker(
              onDateTimeSelected: (value) {
                masterProvider.setSelectedDateTime(value);
              },
              textTitle: "Date & Time of Sample tested *",
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 1,
              controller: masterProvider.addressController,
              // Allows multiline input
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                // Better padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  // Smoother rounded edges
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.blueAccent, width: 1.5), // Focus highlight
                ),
                hintText: "Enter your Address",
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline, // Allows new line input
            ),
            const SizedBox(
              height: 14,
            ),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                maxLines: 2,
                controller: masterProvider.ftkRemarkController,
                // Allows multiline input
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  // Better padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    // Smoother rounded edges
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1.5), // Focus highlight
                  ),
                  hintText: "Enter your remarks",
                  hintStyle:
                      TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction:
                    TextInputAction.newline, // Allows new line input
              ),
            ),
          ],
        ),
      ],
    );
  }
}
