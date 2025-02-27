// Flutter layout for the 'Sample Information' form
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
  String? selectedDistrict;

  int? _selectedSource;
  int? _selectedSubSource;
  int? _selectedPwsType;

  int? _selectedHandPumpType;

  List<String> districtList = [
    'Agra',
    'Aligarh',
    'Amethi',
    'Ayodhya',
    'Bareilly',
    'Gorakhpur',
    'Lucknow',
    'Varanasi',
    'Kanpur',
    'Meerut'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Sample Collection Form',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue[700],
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
    );
  }

  Widget buildStateVillage(Masterprovider masterProvider) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(0),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select village / habitaton',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(
              children: [
                //state data here--------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'State *',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: DropdownButtonFormField<String>(
                          value: masterProvider.selectedStateId,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.blueAccent),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.redAccent, width: 2)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                          ),
                          items: masterProvider.states.map((state) {
                            print('master provider in the calll $state');
                            return DropdownMenuItem<String>(
                              value: state.jjmStateId,
                              child: Text(state.stateName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            masterProvider.setSelectedState(value);
                            if (value != null) {
                              masterProvider.fetchDistricts(value);
                            }
                          },
                          isExpanded: true,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis),
                          icon: Icon(Icons.arrow_drop_down),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10),
                //district data here--------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: CustomDropdown(
                              value: masterProvider.selectedDistrictId,
                              items: masterProvider.districts.map((district) {
                                return DropdownMenuItem<String>(
                                  value: district.jJMDistrictId,
                                  child: Text(
                                    district.districtName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              title: 'District *',
                              onChanged: (value) {
                                masterProvider.setSelectedDistrict(value);
                                if (value != null) {
                                  masterProvider.fetchBlocks(
                                      masterProvider.selectedStateId!, value);
                                }
                              })),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            //block data here--------------
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdown(
                        value: masterProvider.selectedBlockId,
                        items: masterProvider.blocks.map((block) {
                          return DropdownMenuItem<String>(
                            value: block.jjmBlockId,
                            child: Text(
                              block.blockName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        title: "Block *",
                        onChanged: (value) {
                          masterProvider.setSelectedBlock(value);
                          if (value != null) {
                            masterProvider.fetchGramPanchayat(
                                masterProvider.selectedStateId!,
                                masterProvider.selectedDistrictId!,
                                value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),

                /// grampanchayat data here -----------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdown(
                        title: "GP *",
                        value: masterProvider.selectedGramPanchayat,
                        items:
                            masterProvider.gramPanchayat.map((gramPanchayat) {
                          return DropdownMenuItem<String>(
                              value: gramPanchayat.jjmPanchayatId,
                              child: Text(
                                gramPanchayat.panchayatName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ));
                        }).toList(),
                        onChanged: (value) {
                          masterProvider.setSelectedGrampanchayat(value);
                          if (value != null) {
                            masterProvider.fetchVillage(
                                masterProvider.selectedStateId!,
                                masterProvider.selectedDistrictId!,
                                masterProvider.selectedBlockId!,
                                value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ///// village data heree ----------
            CustomDropdown(
              title: "Village *",
              value: masterProvider.selectedVillage,
              items: masterProvider.village.map((village) {
                return DropdownMenuItem<String>(
                    value: village.jjmVillageId.toString(),
                    child: Text(
                      village.villageName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ));
              }).toList(),
              onChanged: (value) {
                masterProvider.setSelectedVillage(value);
                if (value != null) {
                  masterProvider.fetchHabitations(
                      masterProvider.selectedStateId!,
                      masterProvider.selectedDistrictId!,
                      masterProvider.selectedBlockId!,
                      masterProvider.selectedGramPanchayat!,
                      value);
                  masterProvider.fetchSchemes(
                      masterProvider.selectedVillage!, "0");
                }
              },
            ),
            SizedBox(height: 12),
            ///// habitation  data heree ----------
            CustomDropdown(
              title: "Habitation",
              value: masterProvider.selectedHabitation,
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
                );
              }).toList(),
              onChanged: (value) {
                masterProvider.setSelectedScheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSampleTaken(Masterprovider masterProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
                    value: 3,
                    child: Text('WTP of PWS schemes (Treatment)'),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text('Storage Structure (ESR/GSR)'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('Households /school /AWCs'),
                  ),
                  DropdownMenuItem(
                    value: 6,
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
            ),

            SizedBox(height: 16),
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
          visible: masterProvider.selectedSource == 2,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 1.5),
              borderRadius: BorderRadius.circular(8),
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
                  'Select Sub-Source:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: masterProvider.selectedSubSource,
                      onChanged: (value) {
                        masterProvider.setSelectedSubSource(value);
                      },
                    ),
                    Text('Ground water sources (GW)')
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: masterProvider.selectedSubSource,
                      onChanged: (value) {
                        masterProvider.setSelectedSubSource(value);
                      },
                    ),
                    Text('Surface water sources (SW)')
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: masterProvider.selectedSubSource == 1 ||
              masterProvider.selectedSource == 2,
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
                Text(
                  'PWS Type:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: masterProvider.selectedPwsType,
                      onChanged: (value) {
                        masterProvider.setSelectedPwsSource(value);
                        if (value != null) {
                          masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              "0",
                              masterProvider.selectedSource.toString(),
                              masterProvider.selectedSubSource.toString(),
                              masterProvider.selectedPwsType.toString(),
                              "0",
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!);
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
                        masterProvider.setSelectedPwsSource(value);
                        if (value != null) {
                          masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              "0",
                              masterProvider.selectedSource.toString(),
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
        Visibility(
          visible: masterProvider.selectedPwsType != null,
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
      ],
    );
  }

  Widget buildTreatmentWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedSource == 3,
      child: Column(
        children: [
          CustomDropdown(
            value: masterProvider.selectedBlockId,
            items: masterProvider.blocks.map((block) {
              return DropdownMenuItem<String>(
                value: block.jjmBlockId,
                child: Text(
                  block.blockName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
            title: "Select water treatment plant (WTP)",
            onChanged: (value) {
              masterProvider.setSelectedBlock(value);
              if (value != null) {
                masterProvider.fetchGramPanchayat(
                    masterProvider.selectedStateId!,
                    masterProvider.selectedDistrictId!,
                    value);
              }
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
    );
  }

  Widget buildEsrWater(Masterprovider masterProvider) {
    return Visibility(
      visible: masterProvider.selectedSource == 4,
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
      visible: masterProvider.selectedSource == 5,
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
          visible: masterProvider.selectedSource == 6,
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
