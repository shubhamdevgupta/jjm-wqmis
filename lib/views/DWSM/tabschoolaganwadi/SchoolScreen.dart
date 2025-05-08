import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/Showerrormsg.dart';
import 'package:provider/provider.dart';

import '../../../providers/dwsmProvider.dart';
import '../../../services/LocalStorageService.dart';
import '../../../utils/AppStyles.dart';
import '../../../utils/Camera.dart';
import '../../../utils/CustomDropdown.dart';
import '../../../utils/LoaderUtils.dart';
import '../../../utils/toast_helper.dart';

class SchoolScreen extends StatefulWidget {
  @override
  _SchoolScreen createState() => _SchoolScreen();
}

class _SchoolScreen extends State<SchoolScreen> {
  final LocalStorageService _localStorage = LocalStorageService();
  String userId = '';
  String stateId = '';
  final CameraHelper _cameraHelper = CameraHelper();

  TextEditingController remarkController = TextEditingController();


  void initState() {
    super.initState();
    userId = _localStorage.getString(AppConstants.prefUserId)!;
    stateId = _localStorage.getString(AppConstants.prefStateId)!;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<DwsmDashboardProvider>(context, listen: false),
      child: Consumer<DwsmDashboardProvider>(
        builder: (context, dwsmprovider, child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: dwsmprovider.isLoading
                  ? LoaderUtils.conditionalLoader(isLoading: dwsmprovider.isLoading)
                  :SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      dwsmprovider.schoolResultList.isEmpty?AppTextWidgets.errorText(dwsmprovider.errorMsg):
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
                      Visibility(
                          visible: dwsmprovider.selectedSchoolResult!=null,
                          child: Column(
                        children: [
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
                                    Icon(Icons.school_rounded,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${dwsmprovider.selectedSchoolName ?? "N/A"}',
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
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 1.5),
                                  ),
                                  hintText: "Enter your remarks",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600),
                                  suffixIcon: remarkController.text.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(Icons.clear,
                                        color: Colors.grey),
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
                                  Divider(
                                      thickness: 1,
                                      color: Colors.grey.shade300),
                                  SizedBox(height: 2),
                                  Center(
                                    child: _cameraHelper.imageFile == null
                                        ? GestureDetector(
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
                                        padding: const EdgeInsets.all(24),
                                        child: Icon(Icons.camera_alt,
                                            size: 40, color: Colors.blue),
                                      ),
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
                                                  _cameraHelper
                                                      .imageFile!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon: Icon(Icons.close,
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
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
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
                                    Divider(
                                        thickness: 1,
                                        color: Colors.grey.shade300),
                                    SizedBox(height: 8),
                                    // Row for Latitude and Longitude
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                color: Colors.blue, size: 18),
                                            Text(
                                              'Latitude: ${dwsmprovider.currentLatitude?.toStringAsFixed(5)}',
                                              // Reduces to 3 decimal places
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black
                                                      .withOpacity(0.7)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 12),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                color: Colors.blue, size: 18),
                                            Text(
                                              'Longitude: ${dwsmprovider.currentLongitude?.toStringAsFixed(5)}',
                                              // Reduces to 3 decimal places
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black
                                                      .withOpacity(0.7)),
                                            ),
                                          ],
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
                                if (validate(dwsmprovider)){
                                  LoaderUtils.conditionalLoader(isLoading: dwsmprovider.isLoading);
                                  await dwsmprovider.submitFtkData(
                                      int.parse(userId),
                                      int.parse(
                                          dwsmprovider.selectedSchoolResult!),
                                      int.parse(stateId),
                                      _cameraHelper.base64Image!,
                                      "2025-2026",
                                      remarkController.text,
                                      dwsmprovider.currentLatitude.toString(),
                                      dwsmprovider.currentLatitude.toString(),
                                      dwsmprovider.deviceId!, () {
                                    showResponse(dwsmprovider);
                                  });
                                }else{
                                  ToastHelper.showSnackBar(context, dwsmprovider.errorMsg);
                                }
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
                      ))

                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool validate(DwsmDashboardProvider dwsmprovider) {
    if (dwsmprovider.selectedSchoolResult == null) {
      dwsmprovider.errorMsg="Please Select School first.";
      return false;
    }
    if (_cameraHelper.imageFile == null) {
      dwsmprovider.errorMsg="Please capture an image first.";
      return false;
    }
    return true;
  }

  void showResponse(DwsmDashboardProvider dwsmprovider) {
    if (dwsmprovider.baseStatus == 1) {
      showDialog(
        context: context,
        barrierDismissible: false, // Disable tap outside to dismiss
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.only(top: 20),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          title: Column(
            children: [
              Image.asset(
                'assets/check.png',
                // <-- Your success image (PNG) path here
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
            dwsmprovider.ftkSubmitResponse ??
                'Operation completed successfully!',
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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

}
