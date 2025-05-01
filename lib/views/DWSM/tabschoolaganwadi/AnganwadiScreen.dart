import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';
import 'package:provider/provider.dart';

import '../../../models/DWSM/SchoolinfoResponse.dart';
import '../../../models/LabInchargeResponse/AllLabResponse.dart';
import '../../../providers/dwsmDashboardProvider.dart';
import '../../../providers/masterProvider.dart';
import '../../../services/LocalStorageService.dart';
import '../../../utils/Camera.dart';
import '../../../utils/CustomSearchableDropdown.dart';
import '../../../utils/LoaderUtils.dart';

class AnganwadiScreen extends StatefulWidget {
  @override
  _AnganwadiScreen createState() => _AnganwadiScreen();
}

class _AnganwadiScreen extends State<AnganwadiScreen> {
  late Masterprovider masterProvider;
  late DwsmDashboardProvider dwsmDashboardProvider ;
  final CameraHelper _cameraHelper = CameraHelper();
  @override
  void initState() {
    super.initState();
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DwsmDashboardProvider>(context, listen: false).fetchSchoolInfo(int.parse(masterProvider.selectedStateId!),int.parse(masterProvider.selectedDistrictId!),0,0,0,1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final paramProvider = Provider.of<ParameterProvider>(context, listen: true);
    return ChangeNotifierProvider.value(
      value: Provider.of<ParameterProvider>(context, listen: false),
      child: Consumer<ParameterProvider>(
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
                              provider.setSelectedLab(selectedSchool.name);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),


                          Card(
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
                                    "Anganwadi Details",
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
                                      Icon(Icons.bungalow_sharp,
                                          color: Colors.green),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Anganwadi Name: ${paramProvider.labIncharge?.labName ?? "N/A"}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  Row(
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
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
                                    // Hide Camera Icon if Image is Captured
                                    if (_cameraHelper.imageFile == null)
                                      GestureDetector(
                                        onTap: _cameraHelper.pickFromCamera,
                                        child: Container(
                                          child: Image.asset(
                                            'assets/camera.png', // Replace with your logo file path
                                            width: 60, // Adjust width
                                            height: 80, // Adjust height
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 16),

                                    // Display Image if Captured
                                    if (_cameraHelper.imageFile != null) ...[
                                      // Image Preview and Cross Button
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
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                                onPressed: _cameraHelper.removeImage,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                )
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
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            ),
                            onPressed: () {

                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          )
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
