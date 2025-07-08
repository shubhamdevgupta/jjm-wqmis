import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/utils/custom_screen/CustomDropdown.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/dwsmProvider.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';

class DwsmLocation extends StatefulWidget {
  const DwsmLocation({super.key});

  @override
  State<DwsmLocation> createState() => _DwsmLocation();
}

class _DwsmLocation extends State<DwsmLocation> {
  final session = UserSessionManager();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await  session.init();

    });
  }

  @override
  Widget build(BuildContext) {
    final dwsmDashboardProvider =
        Provider.of<DwsmProvider>(context, listen: true);
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
                  fontFamily: 'OpenSans',
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
                      buildStateVillage(masterProvider, dwsmDashboardProvider)
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
      Masterprovider masterProvider, DwsmProvider dwsmprovider) {
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
                    'State',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Dark text for better readability
                        fontFamily: 'OpenSans'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: DropdownButtonFormField<String>(
                      value: session.stateId.toString(),
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
                          value:
                              session.stateId.toString(),
                          // Ensure this matches the selected value
                          child: Text(
                              session.stateName,
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
                      if (value != null) {
                        masterProvider.fetchGramPanchayat(
                            masterProvider.selectedStateId!, session.districtId.toString(), value,session.regId);
                      }
                    },
                    appBarTitle: "Select Block",
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
                  if (value != null) {
                    masterProvider.fetchVillage(masterProvider.selectedStateId!,
                        session.districtId.toString(), masterProvider.selectedBlockId!, value,session.regId);
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
                  if (value != null) {
                    masterProvider.fetchHabitations(
                        masterProvider.selectedStateId!,
                        session.districtId.toString(),
                        masterProvider.selectedBlockId!,
                        masterProvider.selectedGramPanchayat!,
                        value,session.regId);
                    masterProvider.fetchWatersourcefilterList(session.regId);
                  }
                },
                appBarTitle: "Select Village",
              ),
              const SizedBox(height: 12),
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
                appBarTitle: "Select Habitation",
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await masterProvider.fetchLocation();
                    Navigator.pushReplacementNamed(
                        context, AppConstants.navigateToTabSchoolAganwadi);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF096DA8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
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
}
