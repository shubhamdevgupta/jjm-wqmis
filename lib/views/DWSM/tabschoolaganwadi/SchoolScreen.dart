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
  String userId='';
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
    userId=_localStorage.getString(AppConstants.prefUserId)!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DwsmDashboardProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final paramProvider =
        Provider.of<DwsmDashboardProvider>(context, listen: true);
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
                            title: 'Select School',
                            value: provider.schoolResultList.isNotEmpty
                                ? provider.schoolResultList.first.name
                                : null,
                            items: provider.schoolResultList.map((lab) => lab.name ?? '').toList(),
                            onChanged: (selectedLabText) {
                              if (selectedLabText == null)
                                return; // Handle null case

                              final selectedLab = provider.schoolResultList.firstWhere(
                                    (lab) => lab.name == selectedLabText,
                                orElse: () => SchoolResult(name: 'name', id: 0, demonstrated: 0), // Default to a nullable object
                              );
                              provider.setSelectedSchool(selectedLab.id);
                            },
                          ),
                      /*    CustomSearchableDropdown(
                            title: "",
                            value: provider.selectedSchoolResult,
                            items: provider.schoolResult
                                .map((school) =>
                                    school.name ??
                                    '') // Display text, not value
                                .toList(),
                            onChanged: (value) {
                              if (value == null)
                                return; // Handle null case

                              final selectedSchool = provider.schoolResult.firstWhere(
                                    (school) => school.name == value,
                                orElse: () => SchoolResult(
                                    name: "",
                                    id:0, demonstrated: 0
                                    ), // Default to a nullable object
                              );
                              provider.setSelectedSchool(selectedSchool.id);
                            },
                          ),*/
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
                                await dwsmprovider.submitFTK(
                                  userId: int.parse(userId),
                                  schoolId: dwsmprovider.selectedSchoolResult!,
                                  stateId: 31,
                                  photoBase64: _cameraHelper.base64Image!,
                                  fineYear: "2025-2026",
                                  remark: remarkController.text,
                                  latitude:
                                      dwsmprovider.currentLatitude.toString(),
                                  longitude:
                                      dwsmprovider.currentLatitude.toString(),
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
