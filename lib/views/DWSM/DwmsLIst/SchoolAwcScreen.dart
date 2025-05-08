import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:provider/provider.dart';

import '../../../providers/dwsmProvider.dart';
import '../../../utils/AppConstants.dart';

class SchoolAWC extends StatefulWidget {
  final int? type;

  const SchoolAWC({super.key, required this.type});

  @override
  State<SchoolAWC> createState() => _SchoolAWCState();
}

class _SchoolAWCState extends State<SchoolAWC> {
  final LocalStorageService _localStorageService = LocalStorageService();
  String? stateId;
  String? districtId;
  String? titleName = "";

  @override
  void initState() {
    stateId = _localStorageService.getString(AppConstants.prefStateId);
    districtId = _localStorageService.getString(AppConstants.prefDistrictId);
    // districtId = _localStorageService.getString(AppConstants.prefDistrictId);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dashboardProvider =
          Provider.of<DwsmDashboardProvider>(context, listen: false);
      await dashboardProvider.fetchDashboardSchoolList(
          int.parse(stateId!), int.parse(districtId!), widget.type!);
      print('responsssssssss ${dashboardProvider.dashboardSchoolListModel}');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 10) {
      titleName = "School";
    } else {
      titleName = "Anganwadi";
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // Removes the default back button
            centerTitle: true,
            title: Text(
              "$titleName Demonstrations List",
              style: TextStyle(
                fontSize: 20, fontFamily: 'OpenSans',
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
            return provider.isLoading
                ? LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                : ListView.builder(
                    itemCount: provider.dashboardSchoolListModel.length,
                    itemBuilder: (context, index) {
                      final dashboardSchool =
                          provider.dashboardSchoolListModel[index];

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
                                  Text(
                                    "$titleName Details",
                                    style: const TextStyle(
                                      fontSize: 18, fontFamily: 'OpenSans',
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
                                        dashboardSchool.stateName,
                                        dashboardSchool.districtName,
                                        dashboardSchool.blockName,
                                        dashboardSchool.panchayatName,
                                        dashboardSchool.villageName,
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

                              // $titleName Name
                              _infoRow("$titleName Name", "schoolName",
                                  Icons.school, Colors.deepPurple),

                              // Category
                              _infoRow(
                                  "Category",
                                  dashboardSchool.institutionCategory,
                                  Icons.category,
                                  Colors.orange),

                              // Classification
                              _infoRow(
                                  "Classification",
                                  dashboardSchool.institutionSubCategory,
                                  Icons.label,
                                  Colors.green),

                              // Remark
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
            title: Text("$titleName Image"),
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
