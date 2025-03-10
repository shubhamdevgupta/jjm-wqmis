import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:provider/provider.dart';

import '../utils/CustomDropdown.dart';
import 'SampleInformationScreen.dart';

class Locationscreen extends StatefulWidget {
  const Locationscreen({super.key});

  @override
  State<Locationscreen> createState() => _LocationscreenState();
}

class _LocationscreenState extends State<Locationscreen> {
  @override
  Widget build(BuildContext context) {
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
              return SingleChildScrollView(
                child: Column(
                  children: [buildStateVillage(masterProvider)],
                ),
              );
            })));
  }

  Widget buildStateVillage(Masterprovider masterProvider) {
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
              SizedBox(width: 10),
              //district data here--------------
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
                  onPressed: () {

                    if(validateStateVillate(masterProvider)){
                      Navigator.pushReplacementNamed(context, '/savesample');
                    }else{
                      ToastHelper.showToastMessage(masterProvider.errorMsg,backgroundColor: Colors.red);
                    }

                  /*  if (_selectedState.stateName == "--Select State--") {
                      ToastHelper.showToastMessage("Please select all dropdown options before proceeding.", backgroundColor: Colors.red,);
                    } else if (_selectedState == null || _selectedDistrict == null || _selectedBlock == null || _selectedGP == null || _selectedVillage == null) {
                      // Show a toast message if validation fails
                      ToastHelper.showToastMessage("Please select all dropdown options before proceeding.", backgroundColor: Colors.red,);

                      // Optionally, use a Snackbar or AlertDialog for better visibility
                      CustomSnackBar.showError(context, 'Please select all dropdown options before proceeding.');
                    } else if (_selectedState == getStateListData[0] ||
                        _selectedDistrict == getDistrictListData[0] ||
                        _selectedBlock == getBlockListData[0] ||
                        _selectedGP == getGPListData[0] ||
                        _selectedVillage == getVillageListData[0]) {
                      // Show a toast message if validation fails
                      ToastHelper.showToastMessage("Please select all dropdown options before proceeding.", backgroundColor: Colors.red,);

                      // Optionally, use a Snackbar or AlertDialog for better visibility
                      CustomSnackBar.showError(context, 'Please select all dropdown options before proceeding.');
                    } else {
                      // Navigate and pass the selected values to the next screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CatList(
                            state: _selectedState.stateName,
                            district: _selectedDistrict.districtName,
                            block: _selectedBlock.blockName,
                            panchayat: _selectedGP.grampanchayatName,
                            village: _selectedVillage.villageName,
                            stateid: _selectedState.stateId.toString(),
                            districtid: _selectedDistrict.districtId.toString(),
                            blockid: _selectedBlock.blockId.toString(),
                            panchayatid: _selectedGP.grampanchayatId.toString(),
                            villageid: _selectedVillage.villageId.toString(),
                            lgdvillagecode: lgdCodes.toString(),
                          ),
                        ),
                      );
                    }*/
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF096DA8), // Button color
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validateStateVillate(Masterprovider provider) {
      provider.errorMsg = (provider.selectedStateId!.isNotEmpty
          ? (provider.selectedDistrictId!.isNotEmpty
          ? (provider.selectedBlockId!.isNotEmpty
          ? (provider.selectedGramPanchayat!.isNotEmpty
          ? (provider.village.isNotEmpty
          ? (provider.habitationId.isNotEmpty
          ? ""
          : "Please select habitation dropdown before proceeding.")
          : "Please select village dropdown before proceeding.")
          : "Please select GramPanchayat dropdown before proceeding.")
          : "Please select Block dropdown before proceeding.")
          : "Please select District dropdown before proceeding.")
          : "Please select State dropdown before proceeding.");
      return provider.errorMsg.isEmpty;

  }
}
