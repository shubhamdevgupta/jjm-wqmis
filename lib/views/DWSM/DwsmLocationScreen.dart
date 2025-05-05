import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/DWSM/DwsmDashboardScreen.dart';
import 'package:provider/provider.dart';

import '../../providers/ParameterProvider.dart';
import '../../providers/dwsmProvider.dart';
import '../../services/LocalStorageService.dart';
import '../../utils/AppStyles.dart';
import '../../utils/CustomDropdown.dart';

class DwsmLocation extends StatefulWidget {
  @override
  State<DwsmLocation> createState() => _DwsmLocation();
}

class _DwsmLocation extends State<DwsmLocation> {
  final LocalStorageService _localStorage = LocalStorageService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext) {
    final dwsmDashboardProvider = Provider.of<DwsmDashboardProvider>(context, listen: true);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // Removes the default back button
              centerTitle: true,
              title: const Text(
                'Choose Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              //elevation
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
              elevation: 5,
            ),
            body: Consumer<Masterprovider>(
                builder: (context, masterProvider, child) {
              return Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      buildStateVillage(masterProvider,dwsmDashboardProvider)
                    ],
                  )),
                  if (masterProvider.isLoading)
                    LoaderUtils.conditionalLoader(
                        isLoading: masterProvider.isLoading)
                  else if (dwsmDashboardProvider.isLoading)
                    LoaderUtils.conditionalLoader(
                        isLoading: dwsmDashboardProvider.isLoading)
                ],
              );
            })));
  }

  Widget buildStateVillage(
      Masterprovider masterProvider, DwsmDashboardProvider dwsmprovider) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'State *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: DropdownButtonFormField<String>(
                      value: _localStorage.getString(AppConstants.prefStateId),
                      // Ensure this matches the DropdownMenuItem value
                      decoration: InputDecoration(
                        filled: true,
                        // Grey background to indicate it's non-editable
                        fillColor: Colors.grey[300],
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),

                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2), // Avoid focus effect
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value:
                              _localStorage.getString(AppConstants.prefStateId),
                          // Ensure this matches the selected value

                          child: Text(_localStorage
                                  .getString(AppConstants.prefStateName) ??
                              'Unknown State'), // Display state name
                        ),
                      ],
                      onChanged: null,
                      // Disable selection (non-editable)
                      isExpanded: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              //district data here--------------
              Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: CustomDropdown(
                      value: masterProvider.selectedDistrictId,
                      items: masterProvider.districts.map((district) {
                        return DropdownMenuItem<String>(
                          value: district.jjmDistrictId,
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
              SizedBox(height: 12),
              //block data here--------------
              Column(
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
              SizedBox(width: 10),

              /// grampanchayat data here -----------------------
              CustomDropdown(
                title: "GP *",
                value: masterProvider.selectedGramPanchayat,
                items: masterProvider.gramPanchayat.map((gramPanchayat) {
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
                    masterProvider.fetchWatersourcefilterList();
                  }
                },
              ),
              SizedBox(height: 12),
              ///// habitation  data heree ----------
              CustomDropdown(
                title: "Habitation *",
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
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await dwsmprovider.fetchLocation();

                    Navigator.pushReplacementNamed(
                        context, AppConstants.navigateToSubmit_info);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF096DA8),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: AppStyles.textStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateStateVillage(Masterprovider provider) {
    provider.errorMsg = provider.selectedStateId?.isNotEmpty == true
        ? provider.selectedDistrictId?.isNotEmpty == true
            ? provider.selectedBlockId?.isNotEmpty == true
                ? provider.selectedGramPanchayat?.isNotEmpty == true
                    ? (provider.selectedVillage != null &&
                            provider.selectedVillage != "0"
                        ? (provider.selectedHabitation != null &&
                                provider.selectedHabitation != "0"
                            ? ""
                            : "Please select habitation before proceeding.")
                        : "Please select village before proceeding.")
                    : "Please select Gram Panchayat before proceeding."
                : "Please select Block before proceeding."
            : "Please select District before proceeding."
        : "Please select State before proceeding.";

    return provider.errorMsg.isEmpty;
  }
}
