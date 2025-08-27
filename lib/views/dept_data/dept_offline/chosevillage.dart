import 'package:flutter/material.dart';
import 'package:jjm_wqmis/database/database.dart';
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
import 'package:path/path.dart' as _selectedVillages;
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
  late Future<List<String>> _villagesFuture;
  List<String> _allVillages = [
    "Rampur",
    "Lakshmipur",
    "Rajgarh",
    "Sundernagar",
    "Bhavanipur",
    "Chandrapur"
  ];
  List<String> _filteredVillages = [];
  Set<String> _selectedVillages = {}; // ✅ Multi-select
  @override
  void initState() {
    super.initState();
    session.init();
    _villagesFuture = _loadVillages();
    Provider.of<Masterprovider>(context, listen: false).fetchWatersourcefilterList(session.regId);

  }
  Future<List<String>> _loadVillages() async {
    await Future.delayed(const Duration(milliseconds: 800)); // mimic API delay
    _filteredVillages = List.from(_allVillages);
    return _allVillages;
  }

  void _filterVillages(String query) {
    setState(() {
      _filteredVillages = _allVillages
          .where((v) => v.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
    return Container(
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

                    Row(
                      children: [
                        Expanded(
                          child: buildLocationTile(
                            icon: Icons.location_city,
                            label: "State",
                            value:  session.stateName.toString() ?? "N/A",
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: buildLocationTile(
                            icon: Icons.location_city,
                            label: "District",
                            value:  session.districtName.toString() ?? "N/A",
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],



                ),
              ),
            ),




      Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              Row(
                children: [
                  const Icon(Icons.download_for_offline,
                      color: Colors.blue, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Select Villages",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Download villages for offline use and tagging.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 🔎 Sleek Search Bar
              TextField(
                onChanged: _filterVillages,
                decoration: InputDecoration(
                  hintText: "Search village...",
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 🏘 Modern List
              SizedBox(
                height: 350,
                child: FutureBuilder<List<String>>(
                  future: _villagesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error loading villages"));
                    } else if (_filteredVillages.isEmpty) {
                      return const Center(child: Text("No villages found"));
                    }
                    return ListView.separated(
                      itemCount: _filteredVillages.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey.shade200, height: 1),
                      itemBuilder: (context, index) {
                        final village = _filteredVillages[index];
                        final isSelected = _selectedVillages.contains(village);
                        return ListTile(
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 4),
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue.shade50,
                            child: const Icon(Icons.location_on,
                                color: Colors.blue, size: 18),
                          ),
                          title: Text(
                            village,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            activeColor: Colors.blue,
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  _selectedVillages.add(village);
                                } else {
                                  _selectedVillages.remove(village);
                                }
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedVillages.remove(village);
                              } else {
                                _selectedVillages.add(village);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              // ✅ Action button
              if (_selectedVillages.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {




                        print("📥 Starting Offline Data fetch...");

                        // 1. Fetch data from API and wait until it's fully ready
                        await masterProvider.masterVillagesData("2", "4", "56");

                        // Safety check: make sure data exists
                        if (masterProvider.masterVillageData == null) {
                          print("❌ No master data received from API.");
                          return;
                        }

                        print("📊 Habitations: ${masterProvider.masterVillageData!.habitations.length}");
                        print("📊 WaterSourceFilters: ${masterProvider.masterVillageData!.waterSourceFilters.length}");

                        // 2. Open Floor DB
                        final db = await $FloorAppDatabase
                            .databaseBuilder('my_app_database.db')
                            .build();

                        // 3. Clear old data
                        await db.habitationDao.clearTable();
                        await db.waterSourceFilterDao.clearTable();

                        // 4. Insert only if list has data
                        if (masterProvider.masterVillageData!.habitations.isNotEmpty) {
                          await db.habitationDao.insertAll(
                              masterProvider.masterVillageData!.habitations.map((e) => e.toEntity()).toList()
                          );
                          print("✅ Inserted Habitations");
                        } else {
                          print("⚠ No Habitations to insert");
                        }

                        if (masterProvider.masterVillageData!.waterSourceFilters.isNotEmpty) {
                          await db.waterSourceFilterDao.insertAll(
                              masterProvider.masterVillageData!.waterSourceFilters.map((e) => e.toEntity()).toList()
                          );
                          print("✅ Inserted WaterSourceFilters");
                        } else {
                          print("⚠ No WaterSourceFilters to insert");
                        }

                        if (masterProvider.masterVillageData!.schemes.isNotEmpty) {
                          await db.schemeDao.insertAll(
                              masterProvider.masterVillageData!.schemes.map((e) => e.toEntity()).toList()
                          );
                          print("✅ Inserted schemes");
                        } else {
                          print("⚠ No schemes to insert");
                        }

                        if (masterProvider.masterVillageData!.sources.isNotEmpty) {
                          await db.sourcesDao.insertAll(
                              masterProvider.masterVillageData!.sources.map((e) => e.toEntity()).toList()
                          );
                          print("✅ Inserted sources");
                        } else {
                          print("⚠ No sources to insert");
                        }

                        if (masterProvider.masterVillageData!.labs.isNotEmpty) {
                          await db.labDao.insertAll(
                              masterProvider.masterVillageData!.labs.map((e) => e.toEntity()).toList()
                          );
                          print("✅ Inserted labs");
                        } else {
                          print("⚠ No labs to insert");
                        }

                        if (masterProvider.masterVillageData!.parameters.isNotEmpty) {
                          await db.parameterDao.insertAll(
                              masterProvider.masterVillageData!.parameters.map((e) => e.toEntity()).toList()
                          );
                          print("✅ Inserted parameters");
                        } else {
                          print("⚠ No parameters to insert");
                        }

                        if (masterProvider.masterVillageData!.labIncharges.isNotEmpty) {
                          await db.labInchargeDao.insertAll(masterProvider.masterVillageData!.labIncharges.map((e) => e.toEntity()).toList());
                          print("✅ Inserted labIncharges");

                        } else {
                          print("⚠ No labIncharges to insert");
                        }



                        print("🎉 Offline Data fetch & save complete.");






                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Downloading: ${_selectedVillages.join(", ")}",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.cloud_download),
                    label: const Text(
                      "Download Selected",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),

            SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  masterProvider.fetchWatersourcefilterList(session.regId);
                  masterProvider.clearsampleinfo();
                  Navigator.pop(context, true);
                  Navigator.pushReplacementNamed(context, AppConstants.navigateToSampleInformationScreen);

                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF096DA8),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                child: const Text(
                    'Offline Data',
                    style: AppStyles.textStyle
                ),
              ),
            ),

          ],
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
        // 🔽 Removed the dropdown arrow since not needed
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
