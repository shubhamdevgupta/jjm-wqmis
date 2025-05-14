import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/DWSM/DwsmDashboard.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/Showerrormsg.dart';
import 'package:provider/provider.dart';

import '../../../providers/dwsmProvider.dart';
import '../../../services/LocalStorageService.dart';
import '../../../utils/AppStyles.dart';
import '../../../utils/Appcolor.dart';
import '../../../utils/Camera.dart';
import '../../../utils/CurrentLocation.dart';
import '../../../utils/CustomDropdown.dart';
import '../../../utils/LoaderUtils.dart';
import '../../../utils/toast_helper.dart';
import 'TabSchoolAganwadi.dart';

class AnganwadiScreen extends StatefulWidget {
  @override
  _AnganwadiScreen createState() => _AnganwadiScreen();
}

class _AnganwadiScreen extends State<AnganwadiScreen> {
  final LocalStorageService _localStorage = LocalStorageService();
  String userId = '';
  String stateId = '';
  String districtId = '';
  Village? village;

  final CameraHelper _cameraHelper = CameraHelper();
  TextEditingController remarkController = TextEditingController();
  final lat = CurrentLocation.latitude;
  final lng = CurrentLocation.longitude;

  @override
  void initState() {
    super.initState();
    userId = _localStorage.getString(AppConstants.prefUserId)!;
    stateId = _localStorage.getString(AppConstants.prefStateId)!;
    districtId = _localStorage.getString(AppConstants.prefDistrictId)!;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<DwsmProvider>(context, listen: false),
      child: Consumer<DwsmProvider>(
        builder: (context, dwsmprovider, child) {
          return dwsmprovider.isLoading
              ? LoaderUtils.conditionalLoader(isLoading: dwsmprovider.isLoading)
              : Container(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Builder(builder: (context) {
                                switch (dwsmprovider.dataState) {
                                  case DataState.loading:
                                    return LoaderUtils.conditionalLoader(
                                        isLoading: true);

                                  case DataState.error:
                                    return AppTextWidgets.errorText(
                                        dwsmprovider.errorMsg);

                                  case DataState.loaded:
                                    return Column(
                                      children: [
                                        CustomDropdown(
                                          title: "Select Anganwadi",
                                          appBarTitle: "Select Anganwadi",
                                          value: dwsmprovider.selectedAnganwadi,
                                          items: dwsmprovider.anganwadiList
                                              .map((anganwadi) {
                                            return DropdownMenuItem<String>(
                                              value: anganwadi.id.toString(),
                                              child: Text(
                                                anganwadi.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (selectedId) {
                                            final selectedAnnganwadi =
                                                dwsmprovider.anganwadiList
                                                    .firstWhere(
                                              (item) =>
                                                  item.id.toString() ==
                                                  selectedId,
                                            );
                                            dwsmprovider.setSelectedAnganwadi(
                                                selectedId!,
                                                selectedAnnganwadi.name,
                                                selectedAnnganwadi.demonstrated,
                                                selectedAnnganwadi.demonstrated_date.toString()

                                            );

                                            if (dwsmprovider.mDemonstrationId ==
                                                1) {
                                              dwsmprovider
                                                  .fetchDemonstrationList(
                                                      int.parse(stateId),
                                                      int.parse(districtId),
                                                      "2025-2026",
                                                      int.parse(selectedId),
                                                      11, onSuccess: (result) {
                                                village = result;
                                                print(
                                                    "SSS_SS>>> ${village?.districtId} ${village?.districtName}");
                                              });

                                              dwsmprovider
                                                  .showDemonstartionButton(
                                                      false);
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible:
                                              dwsmprovider.selectedAnganwadi !=
                                                  null,
                                          child: Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.1),
                                                    blurRadius: 6,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Header Row
                                                    Row(
                                                      children: [
                                                        Icon(Icons.school_rounded, color: Colors.green, size: 24),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            dwsmprovider.selectedAnganwadiName ?? "N/A",
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              fontFamily: 'OpenSans',
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 16),

                                                    // Demonstration Info Section
                                                    if (dwsmprovider.mDemonstrationId == 1) ...[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.orange.shade50,
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(
                                                            color: Colors.yellow,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // Info Row
                                                            Row(
                                                              children: [
                                                                Icon(Icons.info_outline, size: 20, color: Colors.orange),
                                                                SizedBox(width: 8),
                                                                Expanded(
                                                                  child: Text(
                                                                    "This Anganwadi has already been demonstrated successfully..",
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: 'OpenSans',
                                                                      color: Colors.redAccent,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 10),

                                                            // Demonstration Date Row
                                                            Row(
                                                              children: [
                                                                Icon(Icons.date_range, color: Colors.redAccent, size: 20),
                                                                SizedBox(width: 6),
                                                                Text(
                                                                  "Demonstration:",
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: 'OpenSans',
                                                                  ),
                                                                ),
                                                                SizedBox(width: 6),
                                                                Text(
                                                                  dwsmprovider.selectedAnganwadiDate?.toString() ?? "",
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: 'OpenSans',
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )

                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        dwsmprovider.mDemonstrationId == 1
                                            ? Column(
                                                children: [
                                                  Visibility(
                                                    visible: dwsmprovider
                                                                .selectedAnganwadi !=
                                                            null &&
                                                        !dwsmprovider
                                                            .showDemonstartion,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        print(
                                                            "pppppppppppp before ${dwsmprovider.showDemonstartion}");

                                                        dwsmprovider
                                                            .showDemonstartionButton(
                                                                true);

                                                        print(
                                                            "pppppppppppp after ${dwsmprovider.showDemonstartion}");
                                                      },
                                                      child: Text(
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
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Appcolor.buttonBgColor,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 100,
                                                                vertical: 10),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: dwsmprovider
                                                                .selectedAnganwadi !=
                                                            null &&
                                                        dwsmprovider
                                                            .showDemonstartion,
                                                    child:
                                                        showForm(dwsmprovider),
                                                  ),
                                                  SizedBox(
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
                                                          offset: const Offset(
                                                              0, 4),
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
                                                              Text(
                                                                "Demonstrated Details",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  fontFamily:
                                                                      'OpenSans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blue,
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
                                                                    village !=
                                                                            null
                                                                        ? village
                                                                            ?.stateName
                                                                        : "",
                                                                    village !=
                                                                            null
                                                                        ? village
                                                                            ?.districtName
                                                                        : "",
                                                                    village !=
                                                                            null
                                                                        ? village
                                                                            ?.blockName
                                                                        : "",
                                                                    village !=
                                                                            null
                                                                        ? village
                                                                            ?.panchayatName
                                                                        : "",
                                                                    village !=
                                                                            null
                                                                        ? village
                                                                            ?.villageName
                                                                        : "",
                                                                  ]),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
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

                                                          // School Name
                                                          /*  _infoRow("$titleType Name", "$titleType",
                                          Icons.school, Colors.deepPurple),
                                  */
                                                          // Category
                                                          _infoRow(
                                                              "Category",
                                                              village != null
                                                                  ? village!
                                                                      .InstitutionCategory
                                                                  : "",
                                                              Icons.category,
                                                              Colors.orange),

                                                          // Classification
                                                          _infoRow(
                                                              "Classification",
                                                              village != null
                                                                  ? village!
                                                                      .InstitutionSubCategory
                                                                  : "",
                                                              Icons.label,
                                                              Colors.green),

                                                          _infoRow(
                                                              "Remark",
                                                              village != null
                                                                  ? village!.remark: "",
                                                              Icons.message,
                                                              Colors.teal),




                                                          // Remark
                                                      /*    Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _iconCircle(
                                                                    Icons
                                                                        .comment,
                                                                    Colors
                                                                        .teal),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .teal
                                                                          .shade50,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                    ),
                                                                    child:
                                                                        const Text(
                                                                      "No remark provided",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          color:
                                                                              Colors.teal),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),*/
                                                          const Divider(
                                                              height: 30),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child:
                                                                ElevatedButton
                                                                    .icon(
                                                              onPressed: () {
                                                                String? base64String = village!
                                                                        .photo
                                                                        .contains(
                                                                            ',')
                                                                    ? village
                                                                        ?.photo
                                                                        .split(
                                                                            ',')
                                                                        .last
                                                                    : village
                                                                        ?.photo;

                                                                final imageBytes =
                                                                    base64Decode(
                                                                        base64String!);

                                                                showImage(
                                                                    imageBytes);
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
                                                                    Colors
                                                                        .white,
                                                                padding: const EdgeInsets
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
                                            : showForm(dwsmprovider),
                                      ],
                                    );
                                  case DataState.initial:
                                  default:
                                    return const SizedBox(); // or any placeholder
                                }
                              })),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Future<bool> validate(DwsmProvider dwsmprovider) async {
    await dwsmprovider.fetchDeviceId();

    if (dwsmprovider.selectedAnganwadi == null) {
      dwsmprovider.errorMsg = "Please Select Anganwadi first.";
      return false;
    }
    if (_cameraHelper.imageFile == null) {
      dwsmprovider.errorMsg = "Please capture an image first.";
      return false;
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
                    '/dwsm_dashboard',
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
      ToastHelper.showErrorSnackBar(context, dwsmprovider.errorMsg);
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

  void showImage(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Anganwadi Image"),
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
  }

  Widget showForm(DwsmProvider dwsmprovider) {
    return Visibility(
      visible: dwsmprovider.selectedAnganwadi != null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              width: double.infinity,
              child: TextFormField(
                controller: remarkController,
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 1.5),
                  ),
                  hintText: "Enter your remarks",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                      color: Colors.grey.shade600),
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

          SizedBox(height: 10,),
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
                      "Capture Anganwadi Image",
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
                  SizedBox(height: 5),
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
                      'Geo Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    SizedBox(height: 8),
                    // Row for Latitude and Longitude
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.blue, size: 18),
                            Text(
                              'Latitude: ${lat?.toStringAsFixed(5)}',
                              // Reduces to 3 decimal places
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ],
                        ),
                        SizedBox(width: 12),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.blue, size: 18),
                            Text(
                              'Longitude: ${lng?.toStringAsFixed(5)}',
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
                    if (await validate(dwsmprovider)) {
                      await dwsmprovider.submitFtkData(
                          int.parse(userId),
                          int.parse(dwsmprovider.selectedAnganwadi!),
                          int.parse(stateId),
                          _cameraHelper.base64Image!,
                          "2025-2026",
                          remarkController.text,
                          lat.toString(),
                          lng.toString(),
                          dwsmprovider.deviceId!, () {
                        showResponse(dwsmprovider);
                      });
                    } else {
                      ToastHelper.showSnackBar(context, dwsmprovider.errorMsg);
                    }
                  },
                  child: Text(
                    AppConstants.submitSample,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: AppStyles.buttonStylePrimary()),
            ),
          ),
        ],
      ),
    );
  }
}
