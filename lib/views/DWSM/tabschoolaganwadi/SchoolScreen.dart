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
import '../../../utils/toast_helper.dart';

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

  Future<void> validateAndSubmit(BuildContext context, DwsmDashboardProvider dwsmprovider) async {
    // Check if the camera image is captured
    if (_cameraHelper.imageFile == null) {

      ToastHelper.showToastMessage("Please capture an image first.");
      return; // Exit the function if no image is captured
    }

    await dwsmprovider.submitFTK(
      userId: int.parse(userId),
      schoolId: dwsmprovider.selectedSchoolResult!,
      stateId: 31,
      photoBase64: _cameraHelper.base64Image!,
      fineYear: "2025-2026",
      remark: remarkController.text,
      latitude: dwsmprovider.currentLatitude.toString(),
      longitude: dwsmprovider.currentLatitude.toString(),
      ipAddress: "4135",
    );

    if (dwsmprovider.baseStatus! == 1) {
      showDialog(
        context: context,
        barrierDismissible: false, // Disable tap outside to dismiss
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.only(top: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          title: Column(
            children: [
              Image.asset(
                'assets/check.png', // <-- Your success image (PNG) path here
                height: 60,
                width: 80,
              ),
              const SizedBox(height: 10),
              const Text(
                "Success!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Text(
            dwsmprovider.responseMessage ?? 'Operation completed successfully!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dwsm_dashboard',
                        (route) => false, // Clear back stack
                  );
                },
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      ToastHelper.showErrorSnackBar(context, dwsmprovider.errorMsg);
    }
  }


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



                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.school_rounded, color: Colors.green),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${paramProvider.selectedSchoolResult ?? "N/A"}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                controller: remarkController,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                                  ),
                                  hintText: "Enter your remarks",
                                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                  suffixIcon: remarkController.text.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      remarkController.clear();
                                    },
                                  )
                                      : null,
                                ),
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                              ),
                            ),
                          ),

                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "Capture Sample Image",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey.shade700,
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 1, color: Colors.grey.shade300),
                                  SizedBox(height: 2),
                                  Center(
                                    child: _cameraHelper.imageFile == null
                                        ? GestureDetector(
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
                                        child: Icon(Icons.camera_alt, size: 40, color: Colors.blue),
                                      ),
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
                                            icon: Icon(Icons.close, color: Colors.white),
                                            onPressed: () {
                                              _cameraHelper.removeImage();
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            child: Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Heading
                                    Text(
                                      'Geo Location of Sample Taken',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey.shade700,
                                      ),
                                    ),
                                    Divider(thickness: 1, color: Colors.grey.shade300),
                                    SizedBox(height: 8),
                                    // Row for Latitude and Longitude
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, color: Colors.blue, size: 18),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Latitude: ${dwsmprovider.currentLatitude?.toStringAsFixed(5)}', // Reduces to 3 decimal places
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.7)),
                                          ),
                                        ),
                                        Icon(Icons.location_on, color: Colors.blue, size: 18),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Longitude: ${dwsmprovider.currentLongitude?.toStringAsFixed(5)}', // Reduces to 3 decimal places
                                            style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.7)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),




                          ElevatedButton(
                              onPressed: () async {
                                validateAndSubmit(context, dwsmprovider);
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
