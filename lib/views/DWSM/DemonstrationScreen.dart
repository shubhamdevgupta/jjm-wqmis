import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:provider/provider.dart';

import '../../providers/dwsmProvider.dart';
import '../../services/LocalStorageService.dart';
import '../../utils/AppConstants.dart';

class Demonstrationscreen extends StatefulWidget {
  @override
  State<Demonstrationscreen> createState() => _DemonstrationscreenState();
}

class _DemonstrationscreenState extends State<Demonstrationscreen> {
  final LocalStorageService _localStorage = LocalStorageService();
  String? stateId;
  String? districtId;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateId = _localStorage.getString(AppConstants.prefStateId);
      districtId = _localStorage.getString(AppConstants.prefDistrictId);

      Provider.of<DwsmDashboardProvider>(context, listen: false).loadDwsmDashboardData(stateId == null ? 0 : int.parse(stateId!), districtId == null ? 0 : int.parse(districtId!), "2025-2026");

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // Removes the default back button
          centerTitle: true,
          title: const Text(
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
        body: Consumer<DwsmDashboardProvider>(
            builder: (context, provider, child) {

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
                            final stateId = _localStorage.getString(AppConstants.prefStateId);
                            final districtId = _localStorage.getString(AppConstants.prefDistrictId);

                            Provider.of<DwsmDashboardProvider>(context, listen: false)
                                .loadDwsmDashboardData(
                              stateId == null ? 0 : int.parse(stateId),
                              districtId == null ? 0 : int.parse(districtId),
                              "2025-2026",
                            );
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
                  final base64String = village.photo.split(',').last;
                  final imageBytes = base64Decode(base64String);

                  return Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blueAccent.shade100, width: 1.5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with overlay label
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.memory(
                                imageBytes,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "School Photo",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Row
                              Row(
                                children: const [
                                  Icon(Icons.location_on_outlined, color: Colors.blue, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "School Details",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // School Name with icon
                              Row(
                                children: [
                                  const Icon(Icons.school, color: Colors.deepPurple, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "schoolName", // Replace with actual data if available
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Details Box
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow("State", village.stateName),
                                    _buildInfoRow("District", village.districtName),
                                    _buildInfoRow("Block", village.blockName),
                                    _buildInfoRow("Panchayat", village.panchayatName),
                                    _buildInfoRow("Village", village.villageName),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // User Remark
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.comment, color: Colors.teal, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.teal[50],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "No remark provided", // Replace with actual remark if available
                                        style: TextStyle(
                                          color: Colors.teal[900],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
        }));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
