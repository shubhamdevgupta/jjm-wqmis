// Flutter layout for the 'Sample Information' form
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/CustomDateTimePicker.dart';
import 'package:jjm_wqmis/utils/CustomTextField.dart';
import 'package:provider/provider.dart';

import '../utils/CustomDropdown.dart';

class Sampleinformationscreen extends StatefulWidget {
  @override
  _Sampleinformationscreen createState() => _Sampleinformationscreen();
}

class _Sampleinformationscreen extends State<Sampleinformationscreen> {
  int? _selectedHandPumpType;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
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
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //card for state district selection
                      buildStateVillage(masterProvider),
                      SizedBox(
                        height: 12,
                      ),
                      // card for location of source from where sample taken
                      buildSampleTaken(masterProvider),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              );
            })),
      ),
    );
  }

  Widget buildStateVillage(Masterprovider masterProvider) {
    return Card(
      elevation: 5, // Increased elevation for a more modern shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Slightly increased border radius for a smooth look
      ),
      margin: EdgeInsets.all(5), // Margin to ensure spacing around the card
      color: Colors.white, // Set background color of the card to white
      child: Padding(
        padding: EdgeInsets.all(8.0), // Increased padding for more spacing inside the card
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
                  labelStyle: TextStyle(color: Colors.black),  // Change label color to black
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey, width: 1),  // Grey border when not focused
                  ),

                );
              }).toList(),
              onChanged: (value) {
                masterProvider.setSelectedHabitation(value);
              },
            ),
            SizedBox(height: 12),

            CustomDropdown(
              title: "Scheme Name",
              value: masterProvider.selectedScheme,
              items: masterProvider.schemes.map((scheme) {
                return DropdownMenuItem<String>(
                  value: scheme.schemeId.toString(),
                  child: Text(
                    scheme.schemeName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.redAccent, width: 2),  // Red border for error state
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  fillColor: Colors.white,  // Set background color to white
                  filled: true,  // Ensures background color is applied
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
                  masterProvider.fetchWatersourcefilterList();
                },
                dropdownColor: Colors.white,  // Set dropdown color to white
                isExpanded: true,
                style: TextStyle(color: Colors.black, fontSize: 16),  // Set text color to black
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),  // Set icon color to black
                borderRadius: BorderRadius.circular(5),
                hint: Text('-select-', style: TextStyle(color: Colors.black54)),  // Placeholder color to be more readable
              ),
            )
          ],
        ),
      ),
    );

  }

  Widget buildSampleTaken(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedScheme != null,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*   Text(
              'Please select the location of source from where sample is taken:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),
            Flexible(
              child: DropdownButtonFormField<int>(
                value: masterProvider.selectedSource,
                isExpanded: true,
                // Ensures the dropdown takes full width inside Flexible
                decoration: InputDecoration(
                  labelText: 'Select Source',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                items: [
                  DropdownMenuItem(
                    value: 2,
                    child: Text(
                      'Sources of Schemes (Raw water)',
                      overflow: TextOverflow
                          .ellipsis, // Adds "..." if text is too long
                    ),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('WTP of PWS schemes (Treatment)'),
                  ),
                  DropdownMenuItem(
                    value: 6,
                    child: Text('Storage Structure (ESR/GSR)'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('Households /school /AWCs'),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text(
                      'Handpumps and other private sources',
                      overflow: TextOverflow
                          .ellipsis, // Adds "..." if text is too long
                    ),
                  ),
                ],
                onChanged: (value) {
                  masterProvider.setSelectedSource(value);
                  masterProvider.setSelectedSubSource(null);
                  masterProvider.setSelectedPwsSource(null);
                  setState(() {
                    _selectedHandPumpType = null;
                  });
                },
              ),
            ),*/

            /// data from the apiss
            Card(
              elevation: 5, // Increased elevation for a more modern shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Slightly increased border radius for a smooth look
              ),
              margin: EdgeInsets.all(5), // Margin to ensure spacing around the card
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
                    //  masterProvider.setSelectedScheme(value);
                    /// masterProvider.fetchWatersourcefilterList();
                  },
                ),
              ),
            ),

            SizedBox(height: 10),
            // First Visibility Widget with Border
            buildRawWater(masterProvider),
            buildTreatmentWater(masterProvider),
            buildEsrWater(masterProvider),
            buildHouseholdWater(masterProvider),
            buildHandpumpWater(masterProvider),
          ],
        ),
      ),
    );
  }

  Widget buildRawWater(Masterprovider masterProvider) {
    return Column(
      children: [
        Visibility(
          visible: masterProvider.selectedWtsfilter == "2",
          child: Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Slightly increased border radius for a smooth look
            ),
            margin: EdgeInsets.all(5), // Margin to ensure spacing around the card
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.all(10), // Inner padding
              margin: EdgeInsets.only(top: 12), // Spacing from the previous widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                    'Select Sub-Source:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          // Clear previous selection for PWS type when sub-source changes
                          masterProvider.setSelectedSubSource(value);

                          // Reset PWS type selection to null or default value when changing sub-source
                          masterProvider.setSelectedPwsSource(null); // This will clear the PWS type selection
                          // Optionally, you can reset any other related values or trigger actions
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
                          // Clear previous selection for PWS type when sub-source changes
                          masterProvider.setSelectedSubSource(value);

                          // Reset PWS type selection to null or default value when changing sub-source
                          masterProvider.setSelectedPwsSource(null); // This will clear the PWS type selection
                          // Optionally, you can reset any other related values or trigger actions
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

        Visibility(
          visible: masterProvider.selectedSubSource == 1 || masterProvider.selectedSource == 2,
          child: Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Slightly increased border radius for a smooth look
            ),
            margin: EdgeInsets.all(5), // Margin to ensure spacing around the card
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8), // Inner padding
              margin: EdgeInsets.only(top: 12), // Spacing from the first container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PWS Type:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,fontSize: 15
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: masterProvider.selectedPwsType,
                        onChanged: (value) {
                          // If user selects PWS Type, store the value
                          masterProvider.setSelectedPwsSource(value);

                          // Optionally, trigger actions like fetching new data
                          if (value != null) {
                            masterProvider.fetchSourceInformation(
                                masterProvider.selectedVillage!,
                                "0",
                                3,
                                masterProvider.selectedSubSource.toString(),
                                masterProvider.selectedPwsType.toString(),
                                "0",
                                masterProvider.selectedStateId!,
                                masterProvider.selectedScheme!
                            );
                          }
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
                          // If user selects PWS Type, store the value
                          masterProvider.setSelectedPwsSource(value);

                          // Optionally, trigger actions like fetching new data
                          if (value != null) {
                            masterProvider.fetchSourceInformation(
                                masterProvider.selectedVillage!,
                                "0",
                                3,
                                masterProvider.selectedSubSource.toString(),
                                masterProvider.selectedPwsType.toString(),
                                "0",
                                masterProvider.selectedStateId!,
                                masterProvider.selectedScheme!
                            );
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


        Visibility(
          visible: masterProvider.selectedPwsType != null,
          child: Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Slightly increased border radius for a smooth look
            ),
            margin: EdgeInsets.all(5), // Margin to ensure spacing around the card
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
                  CustomDateTimePicker(onDateTimeSelected: (value) {})
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTreatmentWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedSource == 5,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(10),
        // Inner padding
        margin: EdgeInsets.only(top: 12),
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
                /* if (value != null) {
                  masterProvider.fetchGramPanchayat(
                      masterProvider.selectedStateId!,
                      masterProvider.selectedDistrictId!,
                      value);
                }*/
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
                        masterProvider.setSelectedSubSource(value);
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
                        masterProvider.setSelectedSubSource(value);
                      },
                    ),
                    Text('Disinfection')
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildEsrWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedWtsfilter == "6",
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
          CustomDateTimePicker(onDateTimeSelected: (value) {})
        ],
      ),
    );
    ;
  }

  Widget buildHouseholdWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedWtsfilter == "3",
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
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
                      groupValue: _selectedHandPumpType,
                      onChanged: (value) {
                        setState(() {
                          _selectedHandPumpType = value as int?;
                        });
                      },
                    ),
                    Text('At household'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 4,
                      groupValue: _selectedHandPumpType,
                      onChanged: (value) {
                        setState(() {
                          _selectedHandPumpType = value as int?;
                        });
                      },
                    ),
                    Text('At school/AWCs'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: _selectedHandPumpType == 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align text to the left
              children: [
                CustomTextField(
                  labelText: 'Name of household *',
                  hintText: 'Enter Location',
                  prefixIcon: Icons.cabin_rounded,
                ),
                CustomDateTimePicker(onDateTimeSelected: (value) {})
              ],
            ),
          ),
          Visibility(
            visible: _selectedHandPumpType == 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdown(
                  title: "Select school / AWCs *",
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
                CustomDateTimePicker(onDateTimeSelected: (value) {})
              ],
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
          visible: masterProvider.selectedWtsfilter == "4",
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
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
                      value: 1,
                      groupValue: _selectedHandPumpType,
                      onChanged: (value) {
                        setState(() {
                          _selectedHandPumpType = value as int?;
                        });
                      },
                    ),
                    Text('Govt. Handpump'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: _selectedHandPumpType,
                      onChanged: (value) {
                        setState(() {
                          _selectedHandPumpType = value as int?;
                        });
                      },
                    ),
                    Text('Private source location'),
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
          visible: _selectedHandPumpType == 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align text to the left
            children: [
              CustomDropdown(
                title: "Select Govt. Handpump *",
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
              CustomDateTimePicker(onDateTimeSelected: (value) {})
            ],
          ),
        ),
        Visibility(
          visible: _selectedHandPumpType == 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: 'Type of source *',
                hintText: 'Enter Source type',
                prefixIcon: Icons.edit_calendar_sharp,
              ),
              CustomTextField(
                labelText: 'Enter Location *',
                hintText: 'Enter Location',
                prefixIcon: Icons.dehaze,
              ),
              CustomDateTimePicker(onDateTimeSelected: (value) {})
            ],
          ),
        )
      ],
    );
  }
}
