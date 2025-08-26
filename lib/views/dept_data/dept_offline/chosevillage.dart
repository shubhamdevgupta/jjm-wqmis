import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/block_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/grampanchayat_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/habitation_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/village_response.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/providers/parameter_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/current_location.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/dept_data/dept_dashboard_screen.dart';
import 'package:provider/provider.dart';

class Chosevillage extends StatefulWidget {
  final String flag;
  final String flagFloating; // Declare flag parameter

  const Chosevillage(
      {super.key, required this.flag, required this.flagFloating});

  @override
  State<Chosevillage> createState() => _Chosevillage();
}

class _Chosevillage extends State<Chosevillage> {
  final session = UserSessionManager();
  final lat = CurrentLocation.latitude;
  final lng = CurrentLocation.longitude;
  @override
  void initState() {
    super.initState();
    session.init();
    Provider.of<Masterprovider>(context, listen: false).fetchWatersourcefilterList(session.regId);

  }

  @override
  Widget build(BuildContext context) {
    final paramProvider = Provider.of<ParameterProvider>(context, listen: true);
    return MaterialApp(
        home: Container(
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                // Removes the default back button
                centerTitle: true,
                title: Text(
                  'Choose Location',
                  style: AppStyles.appBarTitle,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboardscreen()),
                            (route) => false,
                      );
                    }
                  },
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
                        ? LoaderUtils.conditionalLoader(
                        isLoading: masterProvider.isLoading)
                        : SingleChildScrollView(
                        child: Column(
                          children: [
                            buildStateVillage(masterProvider, paramProvider)
                          ],
                        ));
                  })),
        ));
  }

  Widget buildStateVillage(
      Masterprovider masterProvider, ParameterProvider paramProvider) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Village Details ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Row 1: State & District
                      /*     Row(
                        children: [
                          Expanded(
                            child: buildLocationTile(
                              icon: Icons.location_city,
                              label: "State",
                              value: session.stateName ?? "Select",
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildLocationTile(
                              icon: Icons.location_city,
                              label: "District",
                              value: session.districtName ?? "Select",
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),*/

                      // Row 2: Block & Gram Panchayat
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                CustomDropdown.openSearchDialog<String>(
                                  context: context,
                                  title: "Select Block",
                                  value: masterProvider.selectedBlockId,
                                  items: masterProvider.blocks.map((block) {
                                    return DropdownMenuItem<String>(
                                      value: block.jjmBlockId,
                                      child: Text(block.blockName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      masterProvider.setSelectedBlock(value);
                                      masterProvider.fetchGramPanchayat(
                                        masterProvider.selectedStateId!,
                                        masterProvider.selectedDistrictId!,
                                        value,
                                        session.regId,
                                      );
                                    }
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: buildLocationTile(
                                icon: Icons.map,
                                label: "Block",
                                value: (masterProvider.selectedBlockId != null &&
                                    masterProvider.selectedBlockId!.isNotEmpty)
                                    ? masterProvider.blocks
                                    .firstWhere(
                                      (b) => b.jjmBlockId == masterProvider.selectedBlockId,
                                  orElse: () => BlockResponse(jjmBlockId: "", blockName: "", jjmDistrictId: ''),
                                ).blockName : "Select",
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                CustomDropdown.openSearchDialog<String>(
                                  context: context,
                                  title: "Select Grampanchayat",
                                  value: masterProvider.selectedGramPanchayat,
                                  items: masterProvider.gramPanchayat
                                      .map((grampanchayat) {
                                    return DropdownMenuItem<String>(
                                      value: grampanchayat.jjmPanchayatId,
                                      child: Text(grampanchayat.panchayatName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      masterProvider
                                          .setSelectedGrampanchayat(value);
                                      masterProvider.fetchVillage(
                                        masterProvider.selectedStateId!,
                                        masterProvider.selectedDistrictId!,
                                        masterProvider.selectedBlockId!,
                                        value,
                                        session.regId,
                                      );
                                    }
                                  },
                                );
                              },
                              child: buildLocationTile(
                                icon: Icons.location_city,
                                label: "Gram Panchayat",
                                value: (masterProvider.selectedGramPanchayat != null &&
                                    masterProvider.selectedGramPanchayat!.isNotEmpty)
                                    ? masterProvider.gramPanchayat
                                    .firstWhere(
                                      (b) => b.jjmPanchayatId == masterProvider.selectedGramPanchayat,
                                  orElse: () => GramPanchayatresponse(jjmPanchayatId: '', panchayatName: ''),
                                )
                                    .panchayatName
                                    : "Select",
                                color: Colors.orange,
                              ),

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Row 3: Village & Habitation
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                CustomDropdown.openSearchDialog<String>(
                                  context: context,
                                  title: "Select Village",
                                  value: masterProvider.selectedVillage,
                                  items: masterProvider.village.map((village) {
                                    return DropdownMenuItem<String>(
                                      value: village.jjmVillageId,
                                      child: Text(village.villageName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      masterProvider.setSelectedVillage(value);

                                      masterProvider.fetchHabitations(
                                        masterProvider.selectedStateId!,
                                        masterProvider.selectedDistrictId!,
                                        masterProvider.selectedBlockId!,
                                        masterProvider.selectedGramPanchayat!,
                                        value,
                                        session.regId,
                                      );
                                    }
                                  },
                                );
                              },
                              child: buildLocationTile(
                                icon: Icons.home,
                                label: "Village",
                                value: (masterProvider.selectedVillage != null &&
                                    masterProvider.selectedVillage!.isNotEmpty)
                                    ? masterProvider.village
                                    .firstWhere(
                                      (b) => b.jjmVillageId == masterProvider.selectedVillage,
                                  orElse: () => Villageresponse(jjmVillageId: '', villageName: '', flag: 0),
                                )
                                    .villageName
                                    : "Select",
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                CustomDropdown.openSearchDialog<String>(
                                  context: context,
                                  title: "Select Habitation",
                                  value: masterProvider.selectedHabitation,
                                  items: masterProvider.habitationId
                                      .map((habitation) {
                                    return DropdownMenuItem<String>(
                                      value: habitation.habitationId,
                                      child: Text(habitation.habitationName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      masterProvider
                                          .setSelectedHabitation(value);
                                    }
                                  },
                                );
                              },
                              child:buildLocationTile(
                                icon: Icons.home_work,
                                label: "Habitation",
                                value: (masterProvider.selectedHabitation != null &&
                                    masterProvider.selectedHabitation!.isNotEmpty)
                                    ? masterProvider.habitationId
                                    .firstWhere(
                                      (b) => b.habitationId == masterProvider.selectedHabitation,
                                  orElse: () => HabitationResponse(
                                    habitationId: '',
                                    habitationName: '',
                                    villageId: '',
                                  ),
                                ).habitationName
                                    : "Select",
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],



                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sample source location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Column(
                        children: masterProvider.wtsFilterList.map((filter) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: InkWell(
                              onTap: () {
                                masterProvider.setSelectedWaterSourcefilter(filter.id);
                                Navigator.pushNamed(context, AppConstants.navigateToSampleInformationScreen);

                                masterProvider.setSelectedWaterSourcefilter(filter.id);
                                if (filter.id != "0" &&
                                    [masterProvider.selectedStateId, masterProvider.selectedDistrictId, masterProvider.selectedVillage, masterProvider.selectedHabitation].every((e) => e != null)) {
                                  masterProvider.fetchSchemes(
                                    session.stateId.toString(),
                                    session.districtId.toString(),
                                    masterProvider.selectedVillage!,
                                    masterProvider.selectedHabitation!,
                                    filter.id,
                                    session.regId,
                                  );
                                }

                              },
                              borderRadius: BorderRadius.circular(8),
                              child: buildLocationTile(
                                  icon: Icons.water_drop,
                                  label: filter.sourceType,
                                  value:  "",
                                  color:  Colors.blue
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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

Widget buildLocationTile({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          radius: 16,
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_downward_sharp, size: 20, color: Colors.black54),
      ],
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
      ? ""
      : "Please select village before proceeding.")
      : "Please select Gram Panchayat before proceeding."
      : "Please select Block before proceeding."
      : "Please select District before proceeding."
      : "Please select State before proceeding.";

  return provider.errorMsg.isEmpty;
}
