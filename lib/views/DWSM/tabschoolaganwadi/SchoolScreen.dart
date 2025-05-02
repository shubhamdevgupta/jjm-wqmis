import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:provider/provider.dart';

import '../../../providers/dwsmDashboardProvider.dart';
import '../../../services/LocalStorageService.dart';
import '../../../utils/AppStyles.dart';
import '../../../utils/Camera.dart';
import '../../../utils/CustomDropdown.dart';
import '../../../utils/LoaderUtils.dart';

class SchoolScreen extends StatefulWidget {
  @override
  _SchoolScreen createState() => _SchoolScreen();
}

class _SchoolScreen extends State<SchoolScreen> {
  late DwsmDashboardProvider dwsmprovider;
  final LocalStorageService _localStorage = LocalStorageService();
  String userId = '';
  String stateId = '';
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
    userId = _localStorage.getString(AppConstants.prefUserId)!;
    stateId = _localStorage.getString(AppConstants.prefStateId)!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DwsmDashboardProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    dwsmprovider.fetchDeviceId();
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
                          CustomDropdown(
                            title: "Select School",
                            value: dwsmprovider.selectedSchoolResult,
                            items: dwsmprovider.schoolResultList.map((school) {
                              return DropdownMenuItem<String>(
                                value: school.id.toString(), // use ID as value
                                child: Text(
                                  school.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedId) {
                              final selectedSchool =
                                  dwsmprovider.schoolResultList.firstWhere(
                                (item) => item.id.toString() == selectedId,
                              );
                              dwsmprovider.setSelectedSchool(
                                selectedId!,
                                selectedSchool.name,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
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
                                Divider(
                                    thickness: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.school_rounded,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${dwsmprovider.selectedSchoolName ?? "N/A"}',
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
                                Divider(
                                    thickness: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: TextFormField(
                                    controller: remarkController,
                                    maxLines: 2,
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
                                Divider(
                                    thickness: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Center(
                                  child: _cameraHelper.imageFile == null
                                      ? Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await _cameraHelper
                                                    .pickFromCamera();
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.blueGrey
                                                          .withOpacity(0.2),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                padding:
                                                    const EdgeInsets.all(24),
                                                child: const Icon(
                                                    Icons.camera_alt,
                                                    size: 40,
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text("Tap to capture",
                                                style: TextStyle(
                                                    color: Colors.black54)),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            Container(
                                              height: 160,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: FileImage(
                                                      _cameraHelper.imageFile!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                icon: const Icon(Icons.close,
                                                    color: Colors.white),
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
                                Divider(
                                    thickness: 1, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Latitude:", style: _labelStyle),
                                        const SizedBox(width: 2),
                                        Text(
                                            "${dwsmprovider.currentLatitude ?? 'N/A'}",
                                            style: _valueStyle),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Longitude:", style: _labelStyle),
                                        const SizedBox(width: 2),
                                        Text(
                                            "${dwsmprovider.currentLongitude ?? 'N/A'}",
                                            style: _valueStyle),
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
                                LoaderUtils.conditionalLoader(isLoading: dwsmprovider.isLoading);
                                await dwsmprovider.submitFtkData(
                                  int.parse(userId),
                                  int.parse(dwsmprovider.selectedSchoolResult!),
                                  int.parse(stateId),
                                  _cameraHelper.base64Image!,
                                  "2025-2026",
                                  remarkController.text,
                                  dwsmprovider.currentLatitude.toString(),
                                  dwsmprovider.currentLatitude.toString(),
                                  dwsmprovider.deviceId!,
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
