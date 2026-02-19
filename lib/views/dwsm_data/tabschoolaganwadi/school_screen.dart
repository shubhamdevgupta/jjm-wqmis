import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/DWSM/ftk_demonstration_list_response.dart';
import 'package:jjm_wqmis/providers/dwsm_provider.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/ImageDialogUtil.dart';
import 'package:jjm_wqmis/utils/app_color.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/camera.dart';
import 'package:jjm_wqmis/utils/location/current_location.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/school_aganwadi_screen.dart';
import 'package:provider/provider.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  _SchoolScreen createState() => _SchoolScreen();
}

class _SchoolScreen extends State<SchoolScreen> {
  final session = UserSessionManager();

  final CameraHelper _cameraHelper = CameraHelper();
  TextEditingController remarkController = TextEditingController();
  VillageInfo? village;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final masterProvider = Provider.of<Masterprovider>(context, listen: false);
    return ChangeNotifierProvider.value(
      value: Provider.of<DwsmProvider>(context, listen: false),
      child: Consumer<DwsmProvider>(
        builder: (context, dwsmprovider, child) {
          return dwsmprovider.isLoading
              ? LoaderUtils.conditionalLoader(isLoading: dwsmprovider.isLoading)
              : Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Builder(builder: (context) {
                              switch (dwsmprovider.dataState) {
                                case DataState.loading:
                                  return LoaderUtils.conditionalLoader(
                                      isLoading: true);

                                case DataState.error:
                                  return AppTextWidgets.errorText(
                                      dwsmprovider.errorMessage);
                                case DataState.loaded:
                                  return Column(
                                    children: [
                                      CustomDropdown(
                                        title: "Select School",
                                        appBarTitle: "Select School",
                                        value:
                                            dwsmprovider.selectedSchoolResult,
                                        items: dwsmprovider.schoolResultList
                                            .map((school) {
                                          return DropdownMenuItem<String>(
                                            value: school.id.toString(),
                                            child: Text(
                                              school.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (selectedId) {
                                          final selectedSchool = dwsmprovider
                                              .schoolResultList
                                              .firstWhere(
                                            (item) =>
                                                item.id.toString() ==
                                                selectedId,
                                          );
                                          dwsmprovider.setSelectedSchool(
                                              selectedId!,
                                              selectedSchool.name,
                                              selectedSchool.demonstrated,
                                            selectedSchool.demonstratedDate
                                                  .toString());
                                          dwsmprovider
                                              .showDemonstartionButton(false);
                                          if (dwsmprovider.mDemonstrationId ==
                                              1) {
                                            dwsmprovider.fetchDemonstrationList(
                                                session.stateId,
                                                session.districtId,
                                                "2025-2026",
                                                selectedId,
                                                10,
                                                session.regId,
                                                onSuccess: (result) {
                                              village = result;
                                            });

                                            dwsmprovider
                                                .showDemonstartionButton(false);
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                          visible: dwsmprovider
                                                  .selectedSchoolResult !=
                                              null,
                                          child: Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .school_rounded,
                                                            color: Colors.green,
                                                            size: 24),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            dwsmprovider
                                                                    .selectedSchoolName ??
                                                                "N/A",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      dwsmprovider.mDemonstrationId == 1
                                          ? Column(
                                              children: [
                                                Visibility(
                                                  visible: dwsmprovider
                                                              .selectedSchoolResult !=
                                                          null &&
                                                      !dwsmprovider
                                                          .showDemonstartion,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          dwsmprovider
                                                              .showDemonstartionButton(
                                                                  true);
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Appcolor
                                                                .buttonBgColor,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "New Demonstration",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'OpenSans',
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                    visible: dwsmprovider
                                                                .selectedSchoolResult !=
                                                            null &&
                                                        dwsmprovider
                                                            .showDemonstartion,
                                                    child: showForm(
                                                        dwsmprovider,
                                                        masterProvider)),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .blue.shade100
                                                            .withOpacity(0.4),
                                                        blurRadius: 12,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Heading

                                                        Row(
                                                          children: [
                                                            _iconCircle(
                                                                Icons
                                                                    .location_city,
                                                                Colors.blue),
                                                            const SizedBox(
                                                                width: 10),
                                                            const Text(
                                                              "Demonstrated Details",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                            height: 30),
                                                        const SizedBox(
                                                            height: 12),

                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            _iconCircle(
                                                                Icons
                                                                    .location_on,
                                                                Colors.red),
                                                            const SizedBox(
                                                                width: 10),
                                                            Expanded(
                                                              child: Text(
                                                                _buildLocationPath([
                                                                  village != null ? village?.stateName : "",
                                                                  village != null ? village?.districtName : "",
                                                                  village != null ? village?.blockName : "",
                                                                  village != null ? village?.panchayatName : "",
                                                                  village != null ? village?.villageName : "",
                                                                ]),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'OpenSans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        // Category
                                                        _infoRow(
                                                            "Category",
                                                            village?.institutionCategory ??
                                                                "",
                                                            Icons.category,
                                                            Colors.orange),

                                                        // Classification
                                                        _infoRow(
                                                            "Classification",
                                                            village?.institutionSubCategory ??
                                                                "",
                                                            Icons.label,
                                                            Colors.green),

                                                        _infoRow(
                                                            "Remark",
                                                            village?.remark ??
                                                                "",
                                                            Icons.message,
                                                            Colors.teal),
                                                        _infoRow(
                                                            "Date",
                                                            dwsmprovider
                                                                .selectedSchoolDate!,
                                                            Icons.message,
                                                            Colors.teal),

                                                        const Divider(
                                                            height: 30),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: ElevatedButton
                                                              .icon(
                                                            onPressed: () {
                                                              String? base64String = village!
                                                                      .photo!
                                                                      .contains(
                                                                          ',')
                                                                  ? village
                                                                      ?.photo!
                                                                      .split(
                                                                          ',')
                                                                      .last
                                                                  : village
                                                                      ?.photo;

                                                              ImageDialogUtil
                                                                  .showImageDialog(
                                                                context:
                                                                    context,
                                                                title:
                                                                    "School Image",
                                                                base64String:
                                                                    base64String,
                                                                shouldFetchDemoList:
                                                                    false,
                                                                // or false if you don't want to fetch
                                                                stateId: null,
                                                                districtId:
                                                                    null,
                                                                regId: null,
                                                                type: null,
                                                              );
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                size: 18),
                                                            label: const Text(
                                                                "View"),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Appcolor
                                                                      .buttonBgColor,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : showForm(
                                              dwsmprovider, masterProvider),
                                    ],
                                  );
                                default:
                                  return const SizedBox(); // or any placeholder
                              }
                            })),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Future<bool> validate(
      DwsmProvider dwsmprovider, Masterprovider masterProvider) async {
    await dwsmprovider.fetchDeviceId();
    if (dwsmprovider.selectedSchoolResult == null) {
      dwsmprovider.errorMessage = "Please Select School first.";
      return false;
    }
    if (_cameraHelper.imageFile == null) {
      dwsmprovider.errorMessage = "Please capture an image first.";
      return false;
    }
    CurrentLocation.refresh();

    if (CurrentLocation.latitude == null || CurrentLocation.longitude == null) {
      await CurrentLocation.getLocation();

      if (CurrentLocation.latitude == null || CurrentLocation.longitude == null) {
        // User cancelled or GPS still off
        ToastHelper.showSnackBar(context, "Location is required to proceed.");
        return false;
      }
    }
    return true;
  }

  void showResponse(DwsmProvider dwsmprovider) {
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
                'assets/icons/check.png',
                // <-- Your success image (PNG) path here
                height: 60,
                width: 80,
              ),
              const SizedBox(height: 10),
              const Text(
                "Success!",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'OpenSans',
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
              fontFamily: 'OpenSans',
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
                    AppConstants.navigateToDwsmDashboard,
                    (route) => false, // Clear back stack
                  );
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      ToastHelper.showErrorSnackBar(context, dwsmprovider.errorMessage);
    }
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

  Widget showForm(DwsmProvider dwsmprovider, Masterprovider masterProvider) {
    return Visibility(
      visible: dwsmprovider.selectedSchoolResult != null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              width: double.infinity,
              child: TextFormField(
                controller: remarkController,
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 1.5),
                  ),
                  hintText: "Enter your remarks",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                      color: Colors.grey.shade600),
                  suffixIcon: remarkController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
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
          const SizedBox(
            height: 5,
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
                    offset: const Offset(0, 2),
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
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey.shade300),
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
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(24),
                              child: const Icon(Icons.camera_alt,
                                  size: 40, color: Colors.blue),
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
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: Card(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading
                    Text(
                      'Geo Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    // Row for Latitude and Longitude
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.blue, size: 18),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Latitude: ${CurrentLocation.latitude?.toStringAsFixed(6)}',
                              // Reduces to 3 decimal places
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.blue, size: 18),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Longitude: ${CurrentLocation.longitude?.toStringAsFixed(6)}',
                              // Reduces to 3 decimal places
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'OpenSans',
                                  color: Colors.black.withOpacity(0.7)),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {

                    if (await validate(dwsmprovider, masterProvider)) {
                      await dwsmprovider.submitDemonstration(
                          int.parse(dwsmprovider.selectedSchoolResult!),
                          session.stateId,
                          _cameraHelper.base64Image!,
                          "2025-2026",
                          remarkController.text,
                          CurrentLocation.latitude!.toStringAsFixed(6),
                          CurrentLocation.longitude!.toStringAsFixed(6),
                          dwsmprovider.deviceId!,
                          session.regId, () {
                        showResponse(dwsmprovider);
                      });
                    } else {
                      ToastHelper.showSnackBar(
                          context, dwsmprovider.errorMessage);
                    }
                  },
                  style: AppStyles.buttonStylePrimary(),
                  child: const Text(
                    AppConstants.submitSample,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
