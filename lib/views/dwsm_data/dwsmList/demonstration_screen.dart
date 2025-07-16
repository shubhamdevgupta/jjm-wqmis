import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/dwsm_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';

class Demonstrationscreen extends StatefulWidget {
  final int? type;

  const Demonstrationscreen({super.key, required this.type});

  @override
  State<Demonstrationscreen> createState() => _DemonstrationscreenState();
}

class _DemonstrationscreenState extends State<Demonstrationscreen> {
  final session= UserSessionManager();
  String? titleType = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await session.init();

    await  Provider.of<DwsmProvider>(context, listen: false).fetchDemonstrationList(
          session.stateId,
          session.districtId,
          "2025-2026",
          "0",
          widget.type!,session.regId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 10) {
      titleType = "School";
    } else {
      titleType = "Anganwadi";
    }
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/icons/header_bg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // Removes the default back button
            centerTitle: true,
            title: const Text(
              "Demonstrations List",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, AppConstants.navigateToDwsmDashboard);
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
          body: Consumer<DwsmProvider>(builder: (context, provider, child) {
            return provider.isLoading
                ? LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                : provider.baseStatus == 0
                    ? Center(
                        child: AppTextWidgets.errorText(provider.errorMessage))
                    : ListView.builder(
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
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 🔷 Top Row: Title + Remove
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      titleType == 'School'
                                          ? Image.asset(
                                              'assets/icons/school.png',
                                              width: 32,
                                              height: 32,
                                            )
                                          : Image.asset(
                                              'assets/icons/anganbadi.png',
                                              width: 30,
                                              height: 32,
                                            ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "$titleType Details",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 30),

                                  /// 🔷 Location Path
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.05),
                                      // 🔹 Light red shade
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _iconCircle(
                                            Icons.location_on, Colors.red),
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
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _infoRow(
                                      "Category",
                                      village.institutionCategory??"NA",
                                      Icons.category,
                                      Colors.orange),

                                  /// 🔷 Info Rows
                                  _infoRow("$titleType Name", "$titleType",
                                      Icons.school, Colors.deepPurple),
                                  _infoRow(
                                      "Classification",
                                      village.institutionSubCategory??"NA",
                                      Icons.label,
                                      Colors.green),
                                  _infoRow("Remark", village.remark??"NA",
                                      Icons.message, Colors.teal),
                                  _infoRow("Date", village.createdOn??"NA",
                                      Icons.message, Colors.blueGrey),

                                  const Divider(height: 30),

                                  /// 🔷 View Button
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        // Show loader only once
                                        try {
                                          // Call the provider function WITHOUT managing loader inside provider
                                          await provider.fetchDemonstrationList(
                                            session.stateId,
                                            session.districtId,
                                            "2025-2026",
                                            village.schoolId??"0",
                                            widget.type!,session.regId,
                                            onSuccess: (result) {

                                              final String? base64String = result.photo!.contains(',')
                                                  ? result.photo!.split(',').last
                                                  : result.photo;

                                              showImage(base64String); // show image in alert
                                            },
                                          );
                                        } catch (e) {
                                          debugPrint("Error fetching demonstration list: $e");
                                          showImage(null); // Fallback if any error
                                        } finally {
                                          // Ensure loader is always dismissed
                                          if (context.mounted) {
                                            LoaderUtils.hideLoaderDialog(context);
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.remove_red_eye, size: 18),
                                      label: const Text("View"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconCircle(icon, color),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05), // Light background tone
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'OpenSans',
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: "$title: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    TextSpan(
                      text: value.isEmpty ? "No data provided" : value,
                    ),
                  ],
                ),
              ),
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

  void showImage(String? base64String) {
    Uint8List? imageBytes;

    // ✅ Step 1: Safely decode base64
    try {
      if (base64String != null && base64String.isNotEmpty) {
        imageBytes = base64Decode(base64String);
        if (imageBytes.isEmpty) {
          imageBytes = null; // Empty image, fallback to no-image
        }
      }
    } catch (e) {
      imageBytes = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$titleType Image"),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageBytes == null
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/ic_no_image.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                const Text(
                  "No Image Found or Invalid Base64 String",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
                : Image.memory(
              imageBytes,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/ic_no_image.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Image Data Corrupted or Invalid Format",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Provider.of<DwsmProvider>(context, listen: false)
                    .fetchDemonstrationList(
                  session.stateId,
                  session.districtId,
                  "2025-2026",
                  "0",
                  widget.type!,
                  session.regId,
                );
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
