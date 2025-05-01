import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/DWSM/SchoolinfoResponse.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:provider/provider.dart';

import '../../../models/LabInchargeResponse/AllLabResponse.dart';
import '../../../providers/dwsmDashboardProvider.dart';
import '../../../providers/masterProvider.dart';
import '../../../services/LocalStorageService.dart';
import '../../../utils/AppStyles.dart';
import '../../../utils/Camera.dart';
import '../../../utils/CustomSearchableDropdown.dart';
import '../../../utils/LoaderUtils.dart';

class SchoolScreen extends StatefulWidget {
  @override
  _SchoolScreen createState() => _SchoolScreen();
}

class _SchoolScreen extends State<SchoolScreen> {
  late DwsmDashboardProvider dwsmprovider;
  final LocalStorageService _localStorage = LocalStorageService();

  final CameraHelper _cameraHelper = CameraHelper();

// Style constants
  final _labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  final _valueStyle = TextStyle(
    fontSize: 14,
    color: Colors.black.withOpacity(0.7),
  );
  TextEditingController remarkController = TextEditingController();

  void initState() {
    super.initState();
    dwsmprovider = Provider.of<DwsmDashboardProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DwsmDashboardProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final paramProvider = Provider.of<DwsmDashboardProvider>(context, listen: true);
    return ChangeNotifierProvider.value(
      value: Provider.of<DwsmDashboardProvider>(context, listen: false),
      child: Consumer<DwsmDashboardProvider>(
        builder: (context, provider, child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomSearchableDropdown(
                            title: "",
                            value: provider.selectedSchoolResult,
                            items: provider.schoolResult
                                .map((school) =>
                            school.name ?? '') // Display text, not value
                                .toList(),
                            onChanged: (selectedSchoolResult) {
                              if (selectedSchoolResult == null)
                                return; // Handle null case

                              final selectedSchool = provider.schoolResult.firstWhere(
                                    (school) => school.name == selectedSchoolResult,
                                orElse: () => SchoolResult(name: "",demonstrated: 0,id: 0), // Default to a nullable object
                              );

                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),


                          /*     Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // Section 1: Lab Incharge Details
                                  Text(
                                    "School Details",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Divider(
                                      thickness: 1,
                                      color: Colors.grey.shade300),
                                  // Divider for separation

                                  SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Icon(Icons.school_rounded,
                                          color: Colors.green),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          ' ${paramProvider.selectedSchoolResult ?? "N/A"}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                            *//*      Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.redAccent),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Address: ${paramProvider.labIncharge?.address ?? "N/A"}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),*//*
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Show camera icon if image not picked yet
                                    if (_cameraHelper.imageFile == null)
                                      GestureDetector(
                                        onTap: () async {
                                          await _cameraHelper.pickFromCamera();
                                          setState(() {}); // Refresh the UI to show the image
                                        },
                                        child: Image.asset(
                                          'assets/camera.png',
                                          width: 60,
                                          height: 80,
                                        ),
                                      ),

                                    // Spacer
                                    const SizedBox(width: 16),

                                    // Show captured image
                                    if (_cameraHelper.imageFile != null)
                                      Stack(
                                        children: [
                                          Container(
                                            height: 150,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: FileImage(_cameraHelper.imageFile!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              icon: const Icon(Icons.close, color: Colors.white),
                                              onPressed: () {
                                                _cameraHelper.removeImage();
                                                setState(() {}); // Refresh UI to remove image
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  // Rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      Colors.grey.withOpacity(0.3),
                                      // Shadow color
                                      blurRadius: 10,
                                      // Shadow blur
                                      offset: const Offset(
                                          0, 5), // Shadow position
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Geo Location of Sample Taken:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    Divider(
                                        thickness: 1,
                                        color: Colors.grey.shade300),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Latitude:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          "${paramProvider.currentLatitude}",
                                          // Display placeholder text if null
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Longitude :',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          "${paramProvider.currentLongitude}",
                                          // Display placeholder text if null
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section 1: School Details
                                Text(
                                  "School Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade700,
                                  ),
                                ),
                                Divider(thickness: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.school_rounded, color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${paramProvider.selectedSchoolResult ?? "N/A"}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Section 2: Geo Location


                                // Section 3: Remark
                                Text(
                                  "Remarks",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade700,
                                  ),
                                ),
                                Divider(thickness: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: TextFormField(
                                    controller: remarkController,
                                    maxLines: 3,
                                    decoration: const InputDecoration.collapsed(
                                      hintText: "Enter your remarks here...",
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Section 4: Camera Capture
                                Text(
                                  "Capture Sample Image",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade700,
                                  ),
                                ),
                                Divider(thickness: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Center(
                                  child: _cameraHelper.imageFile == null
                                      ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await _cameraHelper.pickFromCamera();
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blueGrey.withOpacity(0.2),
                                                blurRadius: 8,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(24),
                                          child: const Icon(Icons.camera_alt,
                                              size: 40, color: Colors.blue),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text("Tap to capture",
                                          style: TextStyle(color: Colors.black54)),
                                    ],
                                  )
                                      : Stack(
                                    children: [
                                      Container(
                                        height: 160,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          image: DecorationImage(
                                            image: FileImage(_cameraHelper.imageFile!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: const Icon(Icons.close, color: Colors.white),
                                          onPressed: () {
                                            _cameraHelper.removeImage();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Text(
                                  "Geo Location of Sample Taken",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade700,
                                  ),
                                ),
                                Divider(thickness: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Latitude:", style: _labelStyle),
                                        const SizedBox(width: 2),
                                        Text("${dwsmprovider.currentLatitude ?? 'N/A'}", style: _valueStyle),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text("Longitude:", style: _labelStyle),
                                        const SizedBox(width: 2),
                                        Text("${paramProvider.currentLongitude ?? 'N/A'}", style: _valueStyle),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),

                          ElevatedButton(
                              onPressed: () async {
                                final provider = Provider.of<DwsmDashboardProvider>(context, listen: false);
                                await provider.submitFTK(
                                  userId: 1147404,
                                  schoolId: 216439,
                                  stateId: 31,
                                  photoBase64: _cameraHelper.base64Image!,
                                  fineYear: "2025-2026",
                                  remark: "test",
                                  latitude: "8778",
                                  longitude: "8070",
                                  ipAddress: "4135",
                                );

                              },
                              child: Text(
                                AppConstants.submitSample,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              style: AppStyles.buttonStylePrimary()),


                        ],
                      ),
                    ),
                  ),

                  if (provider.isLoading)
                    LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                ],
              ),



            ),
          );
        },
      ),
    );
  }


}