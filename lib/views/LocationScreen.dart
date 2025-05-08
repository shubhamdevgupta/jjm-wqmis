import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:provider/provider.dart';

import '../providers/ParameterProvider.dart';
import '../services/LocalStorageService.dart';
import '../utils/AppStyles.dart';
import '../utils/CustomDropdown.dart';

class Locationscreen extends StatefulWidget {
  final String flag; // Declare flag parameter

  const Locationscreen({super.key, required this.flag });

  @override
  State<Locationscreen> createState() => _LocationscreenState();
}

class _LocationscreenState extends State<Locationscreen> {
  final LocalStorageService _localStorage = LocalStorageService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext) {

    final paramProvider = Provider.of<ParameterProvider>(
        context, listen: true);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // Removes the default back button
              centerTitle: true,
              title: Text(
                'Choose Location',
                style: AppStyles.appBarTitle,
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
                    children: [buildStateVillage(masterProvider,paramProvider)],
                  )),
                  if (masterProvider.isLoading)
                    LoaderUtils.conditionalLoader(
                        isLoading: masterProvider.isLoading)
                  else if(paramProvider.isLoading)
                    LoaderUtils.conditionalLoader(isLoading: paramProvider.isLoading)
                ],
              );
            })));

  }

  Widget buildStateVillage(Masterprovider masterProvider, ParameterProvider paramProvider) {
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

                      value: _localStorage.getString(
                          AppConstants.prefStateId), // Ensure this matches the DropdownMenuItem value
                      decoration: InputDecoration(
                        filled:
                            true, // Grey background to indicate it's non-editable
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
                          value: _localStorage.getString(
                              AppConstants.prefStateId), // Ensure this matches the selected value

                          child: Text(_localStorage.getString(AppConstants.prefStateName) ??
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
                        if (value != null &&value.isNotEmpty) {
                          masterProvider.fetchBlocks(
                              masterProvider.selectedStateId!, value);
                        }
                      },
                    appBarTitle: "Select District",
                      ),
              ),
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
                      if (value != null&&value.isNotEmpty) {
                        masterProvider.fetchGramPanchayat(
                            masterProvider.selectedStateId!,
                            masterProvider.selectedDistrictId!,
                            value);
                      }
                    },
                    appBarTitle: "Select block",

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
                  if (value != null && value.isNotEmpty) {
                    masterProvider.fetchVillage(
                        masterProvider.selectedStateId!,
                        masterProvider.selectedDistrictId!,
                        masterProvider.selectedBlockId!,
                        value);
                  }
                },
                appBarTitle: "Select Gram Panchayat",

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
                  if (value != null && value.isNotEmpty) {
                    masterProvider.fetchHabitations(
                        masterProvider.selectedStateId!,
                        masterProvider.selectedDistrictId!,
                        masterProvider.selectedBlockId!,
                        masterProvider.selectedGramPanchayat!,
                        value);
                  }
                },
                appBarTitle: "Select Village",
              ),
              SizedBox(height: 12),
              ///// habitation  data heree ----------
              CustomDropdown(
                title: "Habitation ",
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(

                  onPressed: () async {
                    print("flagggggggggg ${ widget.flag}");
                    print("loading--------->${paramProvider.isLoading}");
                    await paramProvider.fetchLocation();
                    print("currentLatitude--------->${paramProvider.currentLatitude}");
                    print("currentLongitude--------->${paramProvider.currentLongitude}");
                    print("loading--------->${paramProvider.isLoading}");
                    if (widget.flag == AppConstants.openSampleListScreen) {

                      print('Going to Sample List screen');

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/sampleList',
                        ModalRoute.withName('/dashboard'),
                        arguments: {'flag': widget.flag,'dis' : masterProvider.selectedDistrictId,'block':masterProvider.selectedBlockId},
                      );
                    } else if (widget.flag == AppConstants.openSampleInfoScreen &&
                        validateStateVillage(masterProvider)) {
                      masterProvider.fetchWatersourcefilterList();
                      print('Going to Show information screen');
                      Navigator.pop(context, true);
                      Navigator.pushReplacementNamed(context, AppConstants.navigateToSaveSample);
                    } else {
                      /*ToastHelper.showErrorSnackBar(context, masterProvider.errorMsg);*/
                      ToastHelper.showToastMessage(masterProvider.errorMsg);
                    }

                    //TODO LGD code
                         /*             masterProvider.fetchVillageDetails(
                          paramProvider.currentLongitude!,
                          paramProvider.currentLatitude!);
                      print('Going to Save Sample screen');
                      final hasData = masterProvider.villageDetails.isNotEmpty;
                      final villageLgd = hasData
                          ? masterProvider.villageDetails.first.villageLgd
                          : "0";
                      masterProvider.validateVillage(masterProvider.selectedVillage!,villageLgd);
                      if(masterProvider.validateVillageResponse!.status==1) {
                        Navigator.pushReplacementNamed(context, '/savesample');
                      }else{
                        ToastHelper.showErrorSnackBar(context, 'please check the location ');
                      }*/

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF096DA8),
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 100.0),

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
        ? (provider.selectedVillage != null && provider.selectedVillage != "0"
        ? ""
        : "Please select village before proceeding.")
        : "Please select Gram Panchayat before proceeding."
        : "Please select Block before proceeding."
        : "Please select District before proceeding."
        : "Please select State before proceeding.";

    return provider.errorMsg.isEmpty;
  }
}
