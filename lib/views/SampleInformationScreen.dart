// Flutter layout for the 'Sample Information' form
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/CustomDateTimePicker.dart';
import 'package:jjm_wqmis/utils/CustomTextField.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/views/LabParameterScreen.dart';
import 'package:provider/provider.dart';

import '../utils/CustomDropdown.dart';

class Sampleinformationscreen extends StatefulWidget {
  @override
  _Sampleinformationscreen createState() => _Sampleinformationscreen();
}

class _Sampleinformationscreen extends State<Sampleinformationscreen> {
  final TextEditingController householdController = TextEditingController();
  final TextEditingController handpumpSourceController =
      TextEditingController();
  final TextEditingController handpumpLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          // Navigate back to Dashboard when pressing back button
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false, // Clears all previous routes
          );
          return false; // Prevents default back action
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    }
                  },
                ),
                title: Text(
                  'Sample Collection Form',
                  style: TextStyle(color: Colors.white),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    // Background color for the container
                    borderRadius: BorderRadius.circular(8),
                    // Rounded corners
                    gradient: const LinearGradient(
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
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //card for state district selection
                            buildSampleTaken(masterProvider),
                            SizedBox(
                              height: 12,
                            ),
                            // card for location of source from where sample taken
                          ],
                        ),
                      ),
                    ),
                    if (masterProvider.isLoading)
                      LoaderUtils.conditionalLoader(
                          isLoading: masterProvider.isLoading)
                  ],
                );
              })),
        ),
      ),
    );
  }

  Widget buildSchemeDropDown(Masterprovider masterProvider) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            12), // Slightly increased border radius for a smooth look
      ),
      margin: EdgeInsets.all(5),
      // Margin to ensure spacing around the card
      color: Colors.white,
      // Set background color of the card to white
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for the dropdown
            Text(
              "Select Scheme",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Dark text for better readability
              ),
            ),

            const Divider(
              height: 10,
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 4), // Space between title and dropdown
            // Custom dropdown
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<String>(
                value: masterProvider.selectedScheme,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  // Change label color to black
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1), // Grey border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1), // Grey border when focused
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.redAccent,
                        width: 2), // Red border for error state
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  fillColor: Colors.white,
                  // Set background color to white
                  filled: true, // Ensures background color is applied
                ),
                items: masterProvider.schemes.map((scheme) {
                  return DropdownMenuItem<String>(
                    value: scheme.schemeId.toString(),
                    child: Text(
                      scheme.schemeName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  masterProvider.setSelectedScheme(value);
                  if (masterProvider.selectedWtsfilter == "5") {
                    masterProvider.fetchWTPList(
                        masterProvider.selectedStateId!,
                        masterProvider.selectedScheme!);
                  } else if (masterProvider.selectedWtsfilter == "6") {
                    masterProvider.setSelectedSubSource(0);
                    masterProvider.setSelectedPwsSource(0);
                    masterProvider.setSelectedWTP("0");
                    masterProvider.fetchSourceInformation(
                        masterProvider.selectedVillage!,
                        "0",
                        //habitaion
                        masterProvider.selectedWtsfilter!,
                        masterProvider.selectedSubSource.toString(),
                        masterProvider.selectedPwsType.toString(),
                        masterProvider.selectedWtp!,
                        masterProvider.selectedStateId!,
                        masterProvider.selectedScheme!);
                  }
                },
                dropdownColor: Colors.white,
                isExpanded: true,
                style: TextStyle(color: Colors.black, fontSize: 16),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                borderRadius: BorderRadius.circular(5),
                hint: Text('-select-', style: TextStyle(color: Colors.black54)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSampleTaken(Masterprovider masterProvider) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Slightly increased border radius for a smooth look
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomDropdown(
                title:
                    "Please select the location of source from where sample is taken:",
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
                  if (value != null) {
                    masterProvider.fetchSchemes(
                        masterProvider.selectedVillage!, "0", "0", value);
                  }
                },
              ),
            ),
          ),
          buildSchemeDropDown(masterProvider),

          SizedBox(height: 10),
          // First Visibility Widget with Border

          buildRawWater(masterProvider),
          buildWtpWater(masterProvider),
          buildEsrWater(masterProvider),
          buildHouseholdWater(masterProvider),
          buildHandpumpWater(masterProvider),
        ],
      ),
    );
  }

  Widget buildRawWater(Masterprovider masterProvider) {
    return Column(
      children: [
        Visibility(
          visible: masterProvider.selectedWtsfilter == "2" &&
              (masterProvider.selectedScheme?.isNotEmpty ?? false),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(5),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.all(10),
              // Inner padding
              margin: EdgeInsets.only(top: 12),
              // Spacing from the previous widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  Text(
                    'Select Sub-Source Category:',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          masterProvider.setSelectedSubSource(value);

                          Future.delayed(Duration.zero, () {
                            masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              "0",
                              masterProvider.selectedWtsfilter!,
                              value.toString(),
                              "0",
                              // PWS zero
                              "0",
                              // WTP zero
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!,
                            );
                          });
                        },
                      ),
                      Text('Ground water sources (GW)'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          masterProvider.setSelectedSubSource(value);
                          Future.delayed(Duration.zero, () {
                            masterProvider.fetchSourceInformation(
                                masterProvider.selectedVillage!,
                                masterProvider.selectedHabitation!,
                                masterProvider.selectedWtsfilter!,
                                value.toString(),
                                "0",
                                //pws zero
                                "0",
                                // wtp zero
                                masterProvider.selectedStateId!,
                                masterProvider.selectedScheme!);
                          });
                        },
                      ),
                      Text('Surface water sources (SW)'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        //pws type
        /*    Visibility(
          visible: masterProvider.selectedSubSource == 6 && masterProvider.selectedWtsfilter == "2",
          child: Card(
            elevation: 5,
            // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Slightly increased border radius for a smooth look
            ),
            margin: EdgeInsets.all(5),
            // Margin to ensure spacing around the card
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              // Inner padding
              margin: EdgeInsets.only(top: 12),
              // Spacing from the first container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PWS Type:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: masterProvider.selectedPwsType,
                        onChanged: (value) {
                          masterProvider.setSelectedPwsSource(value);
                          print(
                              "----calling for Source of scheme raw water-----");
                          if (value != null) {}
                        },
                      ),
                      Text('PWS with FHTC'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: masterProvider.selectedPwsType,
                        onChanged: (value) {
                          masterProvider.setSelectedPwsSource(value);
                          print(
                              "----calling for Source of scheme raw water-----");
                          if (value != null) {
                            masterProvider.fetchSourceInformation(
                                masterProvider.selectedVillage!,
                                "0",
                                masterProvider.selectedWtsfilter!,
                                masterProvider.selectedSubSource.toString(),
                                masterProvider.selectedPwsType.toString(),
                                "0",
                                masterProvider.selectedStateId!,
                                masterProvider.selectedScheme!);
                          }
                        },
                      ),
                      Text('PWS without FHTC'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),*/
        Visibility(
          visible: masterProvider.selectedSubSource != null &&
              masterProvider.selectedWtsfilter == "2",
          child: Card(
            elevation: 5,
            // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Slightly increased border radius for a smooth look
            ),
            margin: EdgeInsets.all(5),
            // Margin to ensure spacing around the card
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  CustomDropdown(
                    title: "Select Water Source *",
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
                      masterProvider.setSelectedWaterSourceInformation(value);
                    },
                  ),
                  CustomDateTimePicker(onDateTimeSelected: (value) {
                    masterProvider.setSelectedDateTime(value);
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        masterProvider.fetchAllLabs(
                            masterProvider.selectedStateId!,
                            masterProvider.selectedDistrictId!,
                            masterProvider.selectedBlockId!,
                            masterProvider.selectedGramPanchayat!,
                            masterProvider.selectedVillage!,
                            "1");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                    value: masterProvider,
                                    child: Labparameterscreen(),
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF096DA8),
                        // Button color
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 100.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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

  Widget buildWtpWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedWtsfilter == "5" &&
          (masterProvider.selectedScheme?.isNotEmpty ?? false),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 5,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          masterProvider.setSelectedSubSource(value);
                          masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              masterProvider.selectedHabitation!,
                              masterProvider.selectedWtsfilter!,
                              "0",
                              "0",
                              masterProvider.selectedWtp!,
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!);
                          masterProvider.setSelectedSubSource(value);
                        },
                      ),
                      Text('Inlet of WTP')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 6,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          print(
                              "----calling for wtp but now have to stop -----");

                          masterProvider.setSelectedSubSource(value);
                          /*                  masterProvider.fetchSourceInformation(masterProvider.selectedVillage!,
                              masterProvider.selectedHabitation!,
                              masterProvider.selectedWtsfilter!, "0", "0", value.toString(),
                              masterProvider.selectedStateId!, masterProvider.selectedStateId!);*/
                        },
                      ),
                      Text('Outlet of WTP')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 7,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          print(
                              "----calling for wtp but now have to stop -----");

                          masterProvider.setSelectedSubSource(value);
                          /*  masterProvider.fetchSourceInformation(masterProvider.selectedVillage!,
                              masterProvider.selectedHabitation!,
                              masterProvider.selectedWtsfilter!, "0", "0", value.toString(),
                              masterProvider.selectedStateId!, masterProvider.selectedStateId!);*/
                        },
                      ),
                      Text('Disinfection')
                    ],
                  ),
                  Visibility(
                    visible: masterProvider.selectedSubSource != null &&
                        masterProvider.selectedWtsfilter == "5",
                    child: Card(
                      elevation: 5,
                      // Increased elevation for a more modern shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Slightly increased border radius for a smooth look
                      ),
                      margin: EdgeInsets.all(5),
                      // Margin to ensure spacing around the card
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
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  masterProvider.fetchAllLabs(
                                      masterProvider.selectedStateId!,
                                      masterProvider.selectedDistrictId!,
                                      masterProvider.selectedBlockId!,
                                      masterProvider.selectedGramPanchayat!,
                                      masterProvider.selectedVillage!,
                                      "1");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider.value(
                                              value: masterProvider,
                                              child: Labparameterscreen(),
                                            )),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF096DA8),
                                  // Button color
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 100.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEsrWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedWtsfilter == "6" &&
          (masterProvider.selectedScheme?.isNotEmpty ?? false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Align text to the left
        children: [
          CustomDropdown(
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
              masterProvider.setSelectedWaterSourceInformation(value);
            },
          ),
          SizedBox(
            height: 10,
          ),
          CustomDateTimePicker(onDateTimeSelected: (value) {
            masterProvider.setSelectedDateTime(value);
          }),
          SizedBox(
            height: 18,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                masterProvider.fetchAllLabs(
                    masterProvider.selectedStateId!,
                    masterProvider.selectedDistrictId!,
                    masterProvider.selectedBlockId!,
                    masterProvider.selectedGramPanchayat!,
                    masterProvider.selectedVillage!,
                    "1");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                            value: masterProvider,
                            child: Labparameterscreen(),
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF096DA8),
                // Button color
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 100.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
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
              padding: EdgeInsets.all(10),
              // Inner padding
              margin: EdgeInsets.only(top: 12),
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
                          masterProvider.setSelectedWaterSourceInformation("0");
                          masterProvider.setSelectedHouseHold(value);
                          masterProvider.setSelectedSubSource(1);
                        },
                      ),
                      Text('At household'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 4,
                        groupValue: masterProvider.selectedHousehold,
                        onChanged: (value) {
                          masterProvider.setSelectedHouseHold(value);
                          masterProvider.setSelectedSubSource(2);
                          masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              masterProvider.selectedHabitation!,
                              masterProvider.selectedWtsfilter!,
                              masterProvider.selectedSubSource.toString(),
                              "0",
                              "0",
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!);
                        },
                      ),
                      Text('At school/AWCs'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
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
                      controller: householdController,
                    ),
                    CustomDateTimePicker(onDateTimeSelected: (value) {
                      masterProvider.setSelectedDateTime(value);
                    }),
                    SizedBox(
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
                    CustomDropdown(
                      title: "Select School / AWCs *",
                      value: masterProvider.waterSource.any((item) =>
                              item.locationId ==
                              masterProvider.selectedWaterSource)
                          ? masterProvider.selectedWaterSource
                          : null, // Ensure valid value
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
                    })
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                masterProvider.otherSourceLocation = householdController.text;
                masterProvider.fetchAllLabs(
                    masterProvider.selectedStateId!,
                    masterProvider.selectedDistrictId!,
                    masterProvider.selectedBlockId!,
                    masterProvider.selectedGramPanchayat!,
                    masterProvider.selectedVillage!,
                    "1");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                            value: masterProvider,
                            child: Labparameterscreen(),
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF096DA8),
                // Button color
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 100.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
              padding: EdgeInsets.all(10),
              // Inner padding
              margin: EdgeInsets.only(top: 12),
              // Spacing from the first container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 5,
                        groupValue: masterProvider.selectedHandpumpPrivate,
                        onChanged: (value) {
                          masterProvider.setSelectedHandpump(value);
                          masterProvider.setSelectedSubSource(1);
                          masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              masterProvider.selectedHabitation!,
                              masterProvider.selectedWtsfilter!,
                              masterProvider.selectedSubSource.toString(),
                              "0",
                              "0",
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!);
                        },
                      ),
                      Text('Govt. Handpump'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 6,
                        groupValue: masterProvider.selectedHandpumpPrivate,
                        onChanged: (value) {
                          masterProvider.setSelectedHandpump(value);
                          masterProvider.setSelectedSubSource(2);
                          masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              masterProvider.selectedHabitation!,
                              masterProvider.selectedWtsfilter!,
                              masterProvider.selectedSubSource.toString(),
                              "0",
                              "0",
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!);
                        },
                      ),
                      Text('Private source location'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: masterProvider.selectedHandpumpPrivate == 5 &&
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
                  CustomDropdown(
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
                      print('Selected Water Source: $value');
                      masterProvider.setSelectedWaterSourceInformation(value);
                    },
                  ),
                  CustomDateTimePicker(onDateTimeSelected: (value) {
                    masterProvider.setSelectedDateTime(value);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        masterProvider.sampleTypeOther =
                            handpumpSourceController.text;
                        masterProvider.otherSourceLocation =
                            handpumpLocationController.text;
                        masterProvider.fetchAllLabs(
                            masterProvider.selectedStateId!,
                            masterProvider.selectedDistrictId!,
                            masterProvider.selectedBlockId!,
                            masterProvider.selectedGramPanchayat!,
                            masterProvider.selectedVillage!,
                            "1");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                    value: masterProvider,
                                    child: Labparameterscreen(),
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF096DA8),
                        // Button color
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 100.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: masterProvider.selectedHandpumpPrivate == 6,
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
                    controller: handpumpSourceController,
                  ),
                  CustomTextField(
                    labelText: 'Enter Location *',
                    hintText: 'Enter Location',
                    prefixIcon: Icons.dehaze,
                    controller: handpumpLocationController,
                  ),
                  CustomDateTimePicker(onDateTimeSelected: (value) {
                    masterProvider.setSelectedDateTime(value);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        masterProvider.sampleTypeOther =
                            handpumpSourceController.text;
                        masterProvider.otherSourceLocation =
                            handpumpLocationController.text;
                        masterProvider.setSelectedWaterSourceInformation("0");
                        masterProvider.fetchAllLabs(
                            masterProvider.selectedStateId!,
                            masterProvider.selectedDistrictId!,
                            masterProvider.selectedBlockId!,
                            masterProvider.selectedGramPanchayat!,
                            masterProvider.selectedVillage!,
                            "1");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                    value: masterProvider,
                                    child: Labparameterscreen(),
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF096DA8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 100.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
}
