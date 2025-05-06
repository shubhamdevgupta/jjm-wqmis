import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/DWSM/DwsmDashboard.dart';
import '../../providers/dwsmProvider.dart';
import '../../utils/AppConstants.dart';


class Demonstrationscreen extends StatefulWidget {

  @override
  State<Demonstrationscreen> createState() => _DemonstrationscreenState();
}

class _DemonstrationscreenState extends State<Demonstrationscreen> {
  LocalStorageService _localStorageService = LocalStorageService();
  String? stateId;
  String? districtId="471";
  @override
  void initState() {

     stateId = _localStorageService.getString(AppConstants.prefStateId);
   //  districtId = _localStorageService.getString(AppConstants.prefDistrictId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DwsmDashboardProvider>(context, listen: false).fetchDemonstrationList(int.parse(stateId!), int.parse(districtId!), "2025-2026",0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration:  const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
    ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // Removes the default back button
            centerTitle: true,
            title:  const Text(
              "Demonstrations List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),


            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                }
              },
            ),

            //elevation
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF096DA8), // Dark blue color
                    Color(0xFF3C8DBC), // Green color
                  ],
                  begin: Alignment.topCenter, // Start at the top center
                  end: Alignment.bottomCenter, // End at the bottom center
                ),
              ),
            ),
            elevation: 5,
          ),

          body: Consumer<DwsmDashboardProvider>(builder : (context,provider , child){
            if (provider.isLoading) {
              return LoaderUtils.conditionalLoader(isLoading: provider.isLoading);
            }
            if (provider.villages.isEmpty) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_off,
                          size: 48,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No Data Found",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Looks like there’s nothing to show here.\nTry refreshing the data.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          provider.fetchDemonstrationList(int.parse(stateId!), int.parse(districtId!), "2025-2026", 0);
                          },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text("Refresh"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return  ListView.builder(
                itemCount: provider.villages.length,
                itemBuilder: (context, index) {
                  final village = provider.villages[index];

                  return Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Heading
                          Row(
                            children: [
                              _iconCircle(Icons.location_city, Colors.blue),
                              const SizedBox(width: 10),
                              const Text(
                                "School Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          const SizedBox(height: 12),

                          // Location Info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _iconCircle(Icons.location_on, Colors.red),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _buildLocationPath([
                                    village.stateName,
                                    village.districtName,
                                    village.blockName,
                                    village.panchayatName,
                                    village.villageName,
                                  ]),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),


                          // School Name
                          _infoRow("School Name", "schoolName", Icons.school, Colors.deepPurple),

                          // Category
                          _infoRow("Category", village.InstitutionCategory, Icons.category, Colors.orange),

                          // Classification
                          _infoRow("Classification", village.InstitutionSubCategory, Icons.label, Colors.green),

                          // Remark
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _iconCircle(Icons.comment, Colors.teal),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      "No remark provided", // Replace dynamically
                                      style: TextStyle(fontSize: 13, color: Colors.teal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                        const Divider(height: 30),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton.icon(

                            onPressed: () async {
                              LoaderUtils.conditionalLoader(isLoading: provider.isLoading);
                              await provider.fetchDemonstrationList(
                                  int.parse(stateId!),
                                  int.parse(districtId!),
                                  "2025-2026",
                                  village.schoolId, onSuccess: (result) {
                                showImage(result);
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye, size: 18),
                            label: const Text("View"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          })),
    );
  }

  Widget _infoRow(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          _iconCircle(icon, color),
          const SizedBox(width: 10),
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: bgColor, size: 18),
    );
  }

  String _buildLocationPath(List<String?> parts) {
    return parts.where((e) => e != null && e.isNotEmpty).join(" > ");
  }

  void showImage(String result) {
    try {
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image not available at the moment.")),
        );
        return;
      }
      String base64String =
          result.contains(',') ? result.split(',').last : result;
      final imageBytes = base64Decode(base64String);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("School Photo"),
            content: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(imageBytes, fit: BoxFit.contain),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }
}
