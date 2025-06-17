import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/utils/custom_screen/CustomDropdown.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';
import 'package:jjm_wqmis/utils/CurrentLocation.dart';

class Locationscreen extends StatefulWidget {
  final String flag;
  final String flagFloating; // Declare flag parameter

   Locationscreen({super.key, required this.flag , required this.flagFloating });

  @override
  State<Locationscreen> createState() => _LocationscreenState();
}

class _LocationscreenState extends State<Locationscreen> {
  final session = UserSessionManager();
  final lat = CurrentLocation.latitude;
  final lng = CurrentLocation.longitude;
  @override
  void initState()  {
    super.initState();
    session.init();
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
              return masterProvider.isLoading
                      ? LoaderUtils.conditionalLoader(isLoading: masterProvider.isLoading)
                      :SingleChildScrollView(
                      child: Column(
                    children: [buildStateVillage(masterProvider,paramProvider)],
                  ));

            })));

  }

  Widget buildStateVillage(Masterprovider masterProvider, ParameterProvider paramProvider) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'State *',
                    style: TextStyle(
                      fontSize: 16, fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: DropdownButtonFormField<String>(

                      value: session.stateId.toString(), // Ensure this matches the DropdownMenuItem value
                      decoration: InputDecoration(
                        filled:
                            true, // Grey background to indicate it's non-editable
                        fillColor: Colors.grey[300],
                        labelStyle: const TextStyle(color: Colors.blueAccent, fontFamily: 'OpenSans',),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),

                          borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2), // Avoid focus effect
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: session.stateId.toString(), // Ensure this matches the selected value

                          child: Text(session.stateName ,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'OpensSans',
                                  fontWeight:
                                  FontWeight.w500)), // Display state name
                        ),
                      ],
                      onChanged: null,
                      // Disable selection (non-editable)
                      isExpanded: true,
                      style: const TextStyle(
                        color: Colors.black, fontFamily: 'OpenSans',
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              //district data here--------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'District',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Dark text for better readability
                        fontFamily: 'OpenSans'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: DropdownButtonFormField<String>(
                      value: session.districtId.toString(),
                      // Ensure this matches the DropdownMenuItem value
                      decoration: InputDecoration(
                        filled: true,
                        // Grey background to indicate it's non-editable
                        fillColor: Colors.grey[300],
                        labelStyle: const TextStyle(
                          color: Colors.blueAccent,
                          fontFamily: 'OpenSans',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),

                          borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2), // Avoid focus effect
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: session.districtId.toString(),
                          // Ensure this matches the selected value

                          child: Text(
                              session.districtName,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'OpensSans',
                                  fontWeight:
                                  FontWeight.w500)), // Display state name
                        ),
                      ],
                      onChanged: null,
                      // Disable selection (non-editable)
                      isExpanded: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
              const SizedBox(width: 10),

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
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(

                  onPressed: () async {

                    await masterProvider.fetchLocation();
                    if (widget.flag == AppConstants.openSampleListScreen) {

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppConstants.navigateToSampleListScreen,
                        ModalRoute.withName('/dashboard'),
                        arguments: {'flag': widget.flag,'dis' : masterProvider.selectedDistrictId,'block':masterProvider.selectedBlockId, 'flagFloating': widget.flagFloating,},
                      );
                    } else if (widget.flag == AppConstants.openSampleInfoScreen && validateStateVillage(masterProvider)) {
                      masterProvider.fetchWatersourcefilterList();
                      masterProvider.clearsampleinfo();
                      Navigator.pop(context, true);
                      Navigator.pushReplacementNamed(context, AppConstants.navigateToSampleInformationScreen);
                    } else {
                      /*ToastHelper.showErrorSnackBar(context, masterProvider.errorMsg);*/
                      ToastHelper.showToastMessage(masterProvider.errorMsg);
                    }

                    //TODO LGD code
                     masterProvider.fetchVillageDetails(masterProvider.currentLongitude!, masterProvider.currentLatitude!);
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
                      }

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF096DA8),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: const Text(
                    'Next',
                    style: AppStyles.textStyle
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
