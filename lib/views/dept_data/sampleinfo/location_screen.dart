import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/parameter_provider.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/current_location.dart';

class Locationscreen extends StatefulWidget {
  final String flag;
  final String flagFloating; // Declare flag parameter

   const Locationscreen({super.key, required this.flag , required this.flagFloating });

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
  Widget build(BuildContext context) {

    final paramProvider = Provider.of<ParameterProvider>(
        context, listen: true);
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

              })),
        ));

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
                        "Village Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Row 1: State & District
                      Row(
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
                      ),
                      const SizedBox(height: 12),

                      // Row 2: Block & Gram Panchayat
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showBlockDropdown(context, masterProvider);
                              },
                              child: buildLocationTile(
                                icon: Icons.map,
                                label: "Block",
                                value: masterProvider.selectedBlockId ?? "Select",
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showGramPanchayatDropdown(context, masterProvider);
                              },
                              child: buildLocationTile(
                                icon: Icons.location_city,
                                label: "Gram Panchayat",
                                value: masterProvider.selectedGramPanchayat ?? "Select",
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
                            child: GestureDetector(
                              onTap: () {
                                showVillageDropdown(context, masterProvider);
                              },
                              child: buildLocationTile(
                                icon: Icons.home,
                                label: "Village",
                                value: masterProvider.selectedVillage ?? "Select",
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showHabitationDropdown(context, masterProvider);
                              },
                              child: buildLocationTile(
                                icon: Icons.home_work,
                                label: "Habitation",
                                value: masterProvider.selectedHabitation ?? "Select",
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






            ],
          ),
        ),
      ),
    );
  }


  Widget buildSampleCard({
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color.withOpacity(0.5), width: 1.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.1),
                  ),
                  child: Image.asset(
                    'assets/icons/medical-lab.png',
                    width: 22,
                    height: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text(
                  "Add Sample",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: color,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(10, 10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void showHabitationDropdown(BuildContext context, Masterprovider masterProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: CustomDropdown(
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
                  Navigator.pop(context); // Close the bottom sheet
                },
                appBarTitle: "Select Habitation",
              ),
            );
          },
        );
      },
    );
  }


  void showVillageDropdown(BuildContext context, Masterprovider masterProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: CustomDropdown(
                title: "Village *",
                value: masterProvider.selectedVillage,
                items: masterProvider.village.map((village) {
                  return DropdownMenuItem<String>(
                    value: village.jjmVillageId.toString(),
                    child: Text(
                      village.villageName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  masterProvider.setSelectedVillage(value);
                  if (value != null && value.isNotEmpty) {
                    masterProvider.fetchHabitations(
                      masterProvider.selectedStateId!,
                      masterProvider.selectedDistrictId!,
                      masterProvider.selectedBlockId!,
                      masterProvider.selectedGramPanchayat!,
                      value,session.regId
                    );
                  }
                  Navigator.pop(context); // Close the bottom sheet
                },
                appBarTitle: "Select Village",
              ),
            );
          },
        );
      },
    );
  }

  void showBlockDropdown(BuildContext context, Masterprovider masterProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: CustomDropdown(
                title: "Block *",
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
                onChanged: (value) {
                  masterProvider.setSelectedBlock(value);
                  if (value != null && value.isNotEmpty) {
                    masterProvider.fetchGramPanchayat(
                      masterProvider.selectedStateId!,
                      masterProvider.selectedDistrictId!,
                      value,session.regId
                    );
                  }
                  Navigator.pop(context); // Close the bottom sheet
                },
                appBarTitle: "Select Block",
              ),
            );
          },
        );
      },
    );
  }


  void showGramPanchayatDropdown(
      BuildContext context,
      Masterprovider masterProvider,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: CustomDropdown(
                title: "Gram Panchayat *",
                value: masterProvider.selectedGramPanchayat,
                items: masterProvider.gramPanchayat.map((gramPanchayat) {
                  return DropdownMenuItem<String>(
                    value: gramPanchayat.jjmPanchayatId,
                    child: Text(
                      gramPanchayat.panchayatName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  masterProvider.setSelectedGrampanchayat(value);
                  if (value != null && value.isNotEmpty) {
                    masterProvider.fetchVillage(
                      masterProvider.selectedStateId!,
                      masterProvider.selectedDistrictId!,
                      masterProvider.selectedBlockId!,
                      value,session.regId
                    );
                  }
                  Navigator.pop(context); // Close bottom sheet
                },
                appBarTitle: "Select Gram Panchayat",
              ),
            );
                });
         }
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
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

