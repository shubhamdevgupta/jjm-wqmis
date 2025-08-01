// Flutter layout for the 'Sample Information' form
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_date_time_picker.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_textfield.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/dept_data/sampleinfo/location_screen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/lab_param_screen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/wtp_lab_screen.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';

class Sampleinformationscreen extends StatefulWidget {
  const Sampleinformationscreen({super.key});

  @override
  _Sampleinformationscreen createState() => _Sampleinformationscreen();
}

class _Sampleinformationscreen extends State<Sampleinformationscreen> {
  final session = UserSessionManager();



  @override
  void initState() {
    super.initState();
    session.init();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          // Navigate back to Dashboard when pressing back button
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppConstants.navigateToDashboardScreen,
            (route) => false, // Clears all previous routes
          );
          return false; // Prevents default back action
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/header_bg.png'), fit: BoxFit.cover),
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
                actions: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.location_on_outlined,
                            color: Colors.white),
                        // Cart icon
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              double screenHeight =
                                  MediaQuery.of(context).size.height;
                              double screenwidth =
                                  MediaQuery.of(context).size.width;


                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(10),
                                content: Container(
                                  color: Colors.white,
                                  height: screenHeight * 0.8,
                                  width: screenwidth * 0.99,
                                  child:  const Locationscreen(flag: AppConstants.openSampleInfoScreen,flagFloating: "",), // Your widget
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ],
                title: Text(
                  'Sample collection form',
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
                    ? LoaderUtils.conditionalLoader(isLoading: masterProvider.isLoading)
                    :Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //card for state district selection
                        buildSampleTaken(masterProvider),
                        const SizedBox(
                          height: 12,
                        ),
                        // card for location of source from where sample taken
                      ],
                    ),
                  ),
                );
              })),
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
          Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomDropdown(
                title:
                "Sample source location",
                value: masterProvider.selectedWtsfilter,
                items: masterProvider.wtsFilterList.map((wtsFilter) {
                  return DropdownMenuItem<String>(
                    value: wtsFilter.id.toString(),
                    child: Text(
                      wtsFilter.sourceType,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                  onChanged: (value) {
                    masterProvider.setSelectedWaterSourcefilter(value);
                    if (value != null && value != "0" &&
                        [masterProvider.selectedStateId, masterProvider.selectedDistrictId, masterProvider.selectedVillage, masterProvider.selectedHabitation].every((e) => e != null)) {
                      masterProvider.fetchSchemes(
                        session.stateId.toString(),
                        session.districtId.toString(),
                        masterProvider.selectedVillage!,
                        masterProvider.selectedHabitation!,
                        value,
                        session.regId,
                      );
                    }
                  },
                appBarTitle: "Select Location",
                showSearchBar: false,
              ),
            ),
          ),
          buildSchemeDropDown(masterProvider),

          const SizedBox(height: 10),
          // First Visibility Widget with Border

          buildSourceofScheme(masterProvider),
          buildWtpWater(masterProvider),
          buildEsrWater(masterProvider),
          buildHouseholdWater(masterProvider),
          buildHandpumpWater(masterProvider),
        ],
      ),
    );
  }


  Widget buildSchemeDropDown(Masterprovider masterProvider) {
    return masterProvider.baseStatus==0 && masterProvider.selectedScheme ==null?AppTextWidgets.errorText(masterProvider.errorMsg): Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            12),
      ),
      margin: const EdgeInsets.all(5),
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
                color:
                Colors.black87, // Dark text for better readability


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
                    style: const TextStyle(fontSize: 14, fontFamily: 'OpenSans',),
                  ),
                );
              }).toList(),
              title: "",
              appBarTitle: "Select Scheme",
              showSearchBar: true,
              onChanged: (value) {
                masterProvider.setSelectedScheme(value);

                masterProvider.clearSelection();

                if (masterProvider.selectedWtsfilter == "5") {
                  masterProvider.fetchWTPList(
                    masterProvider.selectedStateId!,
                    value!, session.regId
                  );
                } else if (masterProvider.selectedWtsfilter == "6") {
                  masterProvider.setSelectedSubSource(0);
                  masterProvider.setSelectedWTP("0");
                  masterProvider.fetchSourceInformation(
                    masterProvider.selectedVillage!,
                    masterProvider.selectedHabitation!,
                    masterProvider.selectedWtsfilter!,
                    "0",
                    masterProvider.selectedSubSource.toString(),
                    masterProvider.selectedWtp!,
                    masterProvider.selectedStateId!,
                    masterProvider.selectedScheme!,session.regId
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildSourceofScheme(Masterprovider masterProvider) {
    return Column(
      children: [
        Visibility(
          visible: masterProvider.selectedWtsfilter == "2" && (masterProvider.selectedScheme?.isNotEmpty ?? false),
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
                        child: const Text('Ground water sources (GW)',style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'OpenSans'),),
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
                          child: const Text('Surface water sources (SW)',style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'OpenSans'),)),
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
          visible: masterProvider.selectedSubSource != null &&
              masterProvider.selectedWtsfilter == "2",
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
                          title: "Select Water Source *",
                          appBarTitle: "Water Source",
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
                  CustomDateTimePicker(onDateTimeSelected: (value) {
                    masterProvider.setSelectedDateTime(value);
                  }),
                  const SizedBox(
                    height: 20,
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
                                builder: (context) => ChangeNotifierProvider.value(
                                  value: masterProvider,
                                  child: const Labparameterscreen(),
                                ),
                              ),
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

  //TODO do it after the api change
  Widget buildWtpWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedWtsfilter == "5" &&
          (masterProvider.selectedScheme?.isNotEmpty ?? false),
      child: Column(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  masterProvider.baseStatus==0?AppTextWidgets.errorText(masterProvider.errorMsg):
                  CustomDropdown(
                    value: masterProvider.selectedWtp,
                    items: masterProvider.wtpList.map((wtpData) {
                      return DropdownMenuItem<String>(
                        value: wtpData.wtpId,
                        child: Text(
                          wtpData.wtpName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    title: "Select water treatment plant (WTP)",
                    onChanged: (value) {
                      masterProvider.setSelectedWTP(value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: masterProvider.baseStatus==1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 5,
                              groupValue: masterProvider.selectedSubSource,
                              onChanged: (value) {
                                masterProvider.istreated=0;
                                masterProvider.selectRadioOption(value!);
                              },
                            ),
                            InkWell(
                                onTap: () {
                                  masterProvider.selectRadioOption(5);
                                },
                                child: const Text('Inlet of WTP'))
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 6,
                              groupValue: masterProvider.selectedSubSource,
                              onChanged: (value) {
                                masterProvider.istreated=1;
                                masterProvider.selectRadioOption(value!);
                              },
                            ),
                            InkWell(
                                onTap: () {
                                  masterProvider.selectRadioOption(6);
                                },
                                child: const Text('Outlet of WTP'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: masterProvider.selectedSubSource != null &&
                masterProvider.selectedWtsfilter == "5",
            child: Card(
              elevation: 5,
              // Increased elevation for a more modern shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(5),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align text to the left
                  children: [
                    Visibility(
                      visible: masterProvider.selectedSubSource == 5,
                      child: CustomDropdown(
                        title: "Select Water Source *",
                        value: masterProvider.selectedWaterSource,
                        items: masterProvider.waterSource
                            .map((waterSource) {
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
                    ),
                    CustomDateTimePicker(onDateTimeSelected: (value) {
                      masterProvider.setSelectedDateTime(value);
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (validateWtpWaterFields(masterProvider)) {
                            //    paramProvider.fetchWTPLab(masterProvider.selectedStateId!, masterProvider.selectedWtp!);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                        value: masterProvider,
                                        child: const Wtplabscreen(),
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
                    )
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget buildEsrWater(Masterprovider masterProvider) {
    return Visibility(
        visible: masterProvider.selectedWtsfilter == "6" &&
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
                CustomDateTimePicker(onDateTimeSelected: (value) {
                  masterProvider.setSelectedDateTime(value);
                }),
                const SizedBox(
                  height: 18,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (validateEsrWaterFields(masterProvider)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                    value: masterProvider,
                                    child: const Labparameterscreen(),
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
                )
              ],
            ),
          ),
        ));
  }

  Widget buildHouseholdWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedWtsfilter == "3" &&
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
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () {
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
                        onChanged: (value) {
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          masterProvider.selectRadioOption(4);
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
                    CustomDateTimePicker(onDateTimeSelected: (value) {
                      masterProvider.setSelectedDateTime(value);
                    }),
                    const SizedBox(
                      height: 18,
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
                            title: "Select School / AWCs *",
                            value: masterProvider.waterSource.any((item) =>
                                    item.locationId ==
                                    masterProvider.selectedWaterSource)
                                ? masterProvider.selectedWaterSource
                                : null, // Ensure valid value
                            items:
                                masterProvider.waterSource.map((waterSource) {
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
                    CustomDateTimePicker(onDateTimeSelected: (value) {
                      masterProvider.setSelectedDateTime(value);
                    })
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: masterProvider.selectedHousehold == 3 ||
                masterProvider.selectedHousehold == 4,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (validateHouseholdWaterFields(
                      masterProvider, masterProvider.householdController)) {
                    masterProvider.otherSourceLocation =
                        masterProvider.householdController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                                value: masterProvider,
                                child: const Labparameterscreen(),
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
    );
  }

  Widget buildHandpumpWater(Masterprovider masterProvider) {
    return Column(
      children: [
        Visibility(
          visible: masterProvider.selectedWtsfilter == "4" &&
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
                          masterProvider.cleartxt();
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          masterProvider.cleartxt();
                          masterProvider.selectRadioOption(7);
                        },
                        child: const Text('Govt. Handpump'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 8,
                        groupValue: masterProvider.selectedHandpumpPrivate,
                        onChanged: (value) {
                          masterProvider.cleartxt();
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          masterProvider.cleartxt();
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
          visible: masterProvider.selectedHandpumpPrivate == 7 &&
              masterProvider.selectedWtsfilter == "4",
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
                // Align text to the left
                children: [
                masterProvider.baseStatus==0?AppTextWidgets.errorText(masterProvider.errorMsg):   CustomDropdown(
                    title: "Select Govt. Handpump *",
                    value: masterProvider.waterSource.any((item) =>
                            item.locationId ==
                            masterProvider.selectedWaterSource)
                        ? masterProvider.selectedWaterSource
                        : null, // Ensure value exists in items
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
                      masterProvider.setSelectedWaterSourceInformation(value);
                    },
                  ),
                  CustomDateTimePicker(onDateTimeSelected: (value) {
                    masterProvider.setSelectedDateTime(value);
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (validateHandpumpWaterFields(
                            masterProvider, masterProvider.handpumpSourceController, masterProvider.handpumpLocationController)) {
                          masterProvider.sampleTypeOther = masterProvider.handpumpSourceController.text;
                          masterProvider.otherSourceLocation = masterProvider.handpumpLocationController.text;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                      value: masterProvider,
                                      child: const Labparameterscreen(),
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
                  )
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: masterProvider.selectedHandpumpPrivate == 8 &&
              masterProvider.selectedWtsfilter == "4",
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
                  CustomDateTimePicker(onDateTimeSelected: (value) {
                    masterProvider.setSelectedDateTime(value);
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                      value: masterProvider,
                                      child: const Labparameterscreen(),
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
}
