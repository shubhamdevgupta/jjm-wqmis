import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/SampleListProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/auth/DashboardScreen.dart';
import 'package:jjm_wqmis/views/webView/testReport.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/models/SampleListResponse.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/Aesen.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';
import 'package:jjm_wqmis/utils/DeviceUtils.dart';
import 'package:jjm_wqmis/utils/Showerrormsg.dart';
import 'package:jjm_wqmis/views/LocationScreen.dart';

class SampleListScreen extends StatefulWidget {
  const SampleListScreen({super.key});

  @override
  _SampleListScreenState createState() => _SampleListScreenState();
}

class _SampleListScreenState extends State<SampleListScreen> {

  final session = UserSessionManager();

  bool isLoading = false;
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final encryption = AesEncryption();
  String flag = "";
  String flagfloation = "";

  int? selectedYear;
  int PAGE = 1;
  int C_STATUS = 1;
  String SEARCH = "0";
  String SAMPLE_ID = "0";

  void _selectYear(BuildContext context) async {
    final currentYear = DateTime.now().year;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(currentYear - 100),
              lastDate: DateTime(currentYear + 10),
              initialDate: DateTime(selectedYear ?? currentYear),
              selectedDate: DateTime(selectedYear ?? currentYear),
              onChanged: (DateTime dateTime) {
                setState(() {
                  selectedYear = dateTime.year;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      Masterprovider masterprovider =
          Provider.of<Masterprovider>(context, listen: false);
      Samplelistprovider sampleListProvider =
          Provider.of<Samplelistprovider>(context, listen: false);
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        flag = args['flag'];
        flagfloation = args['flagFloating'];
        String district = args['dis'] ?? "0";
        String block = args['block'] ?? "0";

        if ((flagfloation == AppConstants.totalSamplesSubmitted || flag == AppConstants.openSampleListScreen) && (flagfloation == AppConstants.totalPhysicalSubmitted || flag == AppConstants.openSampleListScreen) && (flag == AppConstants.openSampleListScreen || flagfloation == AppConstants.totalSampleTested)) {
          if (flagfloation == AppConstants.totalSamplesSubmitted) {
            C_STATUS = 1;
          } else if (flagfloation == AppConstants.totalPhysicalSubmitted) {
            C_STATUS = 2;
          } else if (flagfloation == AppConstants.totalSampleTested) {
            C_STATUS = 6;
          }
          sampleListProvider.fetchSampleList(
              session.regId,
              PAGE,
              SEARCH,
              C_STATUS,
              SAMPLE_ID,
              int.parse(masterprovider.selectedStateId ?? "0"),
              int.parse(district),
              int.parse(block),
              int.parse(masterprovider.selectedGramPanchayat ?? "0"),
              int.parse(masterprovider.selectedVillage ?? "0"));
        } else if (flag == AppConstants.totalPhysicalSubmitted ||
            flag == AppConstants.openSampleListScreen) {
          C_STATUS = 2;
          sampleListProvider.fetchSampleList(session.regId, PAGE, SEARCH,
              C_STATUS, SAMPLE_ID, 0, 0, 0, 0, 0);
        } else if (flag == AppConstants.totalSampleTested ||
            flag == AppConstants.openSampleListScreen) {
          sampleListProvider.fetchSampleList(
              session.regId, 1, "0", 6, "0", 0, 0, 0, 0, 0);
        } else if (flag == AppConstants.totalSamplesSubmitted || flag == AppConstants.openSampleListScreen)
        {C_STATUS = 1;
          sampleListProvider.fetchSampleList(session.regId, PAGE, SEARCH, C_STATUS, SAMPLE_ID, 0, 0, 0, 0, 0);
        }else if (flag == AppConstants.knowyoursampledetail || flag == AppConstants.openSampleListScreen)
        {C_STATUS = 0;
          sampleListProvider.fetchSampleList(session.regId, PAGE, SEARCH, C_STATUS, SAMPLE_ID, 0, 0, 0, 0, 0);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    flag = args?['flag'];
    flagfloation = args?['flagFloating'];

    return WillPopScope(
      onWillPop: () async {
        // Navigate back to Dashboard when pressing back button
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppConstants.navigateToDashboardScreen,
          (route) => false, // Clears all previous routes
        );
        return false; // Prevents default back action
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/header_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(8),
                right: Radius.circular(8),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboardscreen()),
                    (route) => false,
                  );
                }
              },
            ),
            title: Text(
              flagfloation != "" ? flagfloation : flag,
              style: AppStyles.appBarTitle,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined,
                    color: Colors.white),
                onPressed: () => _selectYear(context),
              ),
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF096DA8),
                    Color(0xFF3C8DBC),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  double screenHeight = MediaQuery.of(context).size.height;
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(10),
                    content: Container(
                      color: Colors.white,
                      height: screenHeight * 0.8,
                      width: screenHeight * 0.4,
                      child: Locationscreen(
                        flag: AppConstants.openSampleListScreen,
                        flagFloating: flag,
                      ),
                    ),
                  );
                },
              );
            },
            backgroundColor: const Color(0xFF0468B1),
            shape: const CircleBorder(),
            elevation: 4,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          body: Consumer<Samplelistprovider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  const SizedBox(height: 20),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: AppStyles.buttonStylePrimary(
                              backgroundColor: const Color(0xFF0468B1),
                              fontSize: 16,
                              borderRadius: 6,
                              horizontalPadding: 20,
                              verticalPadding: 14),
                          onPressed: () {
                            if (searchController.text.isNotEmpty) {
                              provider.fetchSampleList(session.regId, 1,
                                  "", 0, searchController.text, 0, 0, 0, 0, 0);
                            } else {
                              ToastHelper.showErrorSnackBar(
                                  context, "Please enter sample id");
                            }
                          },
                          child: const Text(
                            "Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expanded to prevent infinite height issue
                  provider.isLoading
                      ? LoaderUtils.conditionalLoader(
                          isLoading: provider.isLoading)
                      : provider.samples.isEmpty
                          ? AppTextWidgets.errorText(provider.errorMsg)
                          : Expanded(
                              child: ListView.builder(
                                itemCount: provider.samples.length,
                                itemBuilder: (context, index) {
                                  Sample sample = provider.samples[
                                      index]; // where result is List<Sample>

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue, width: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // ID Row
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  child: Text(
                                                    "${index + 1}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                //SizedBox(width: 10),

                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black87,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    "ID: ${sample.sampleId ?? 'N/A'}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible:
                                                      sample.currentStatus == 1,
                                                  child:ElevatedButton(
                                                    onPressed: () async {
                                                      bool? confirmDelete = await showDialog<bool>(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text('Confirm Delete'),
                                                            content: const Text('Are you sure you want to delete this sample?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () => Navigator.of(context).pop(false),
                                                                child: const Text('Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () => Navigator.of(context).pop(true),
                                                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );

                                                      if (confirmDelete == true) {
                                                        LoaderUtils.showLoadingWithMessage(context, message: 'Deleting sample...');
                                                        String deviceId = await DeviceInfoUtil.getUniqueDeviceId();
                                                        provider.deleteSample(
                                                          encryption.encryptText(sample.sId.toString()),
                                                          encryption.encryptText(session.regId.toString()),
                                                          encryption.encryptText(deviceId),
                                                              (response) {
                                                            LoaderUtils.hideLoaderDialog(context);
                                                            bool deleted = provider.deleteSampleFromList(index, sample.sId);
                                                            deleted
                                                                ? ToastHelper.showSuccessSnackBar(context, provider.errorMsg)
                                                                : ToastHelper.showSnackBar(context, provider.errorMsg);
                                                          },
                                                              (error) {
                                                            LoaderUtils.hideLoaderDialog(context);
                                                            ToastHelper.showSnackBar(context, error);
                                                          },
                                                        );
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      backgroundColor: Colors.red.shade50,
                                                      foregroundColor: Colors.red.shade700,
                                                      padding: const EdgeInsets.all(2),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: BorderSide(color: Colors.red.shade200),
                                                      ),
                                                    ),
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.delete_outline, size: 24),
                                                      ],
                                                    ),
                                                  ),

                                                ),
                                                Visibility(
                                                  visible:
                                                      sample.currentStatus == 6,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              TestReport(
                                                                  url:
                                                                      'https://ejalshakti.gov.in/WQMIS/Common/final_report_print?s_id=${encryption.encryptText(sample.sId.toString())}'),
                                                        ),
                                                      );
                                                    },
                                                    child: const CircleAvatar(
                                                      backgroundColor:
                                                          Colors.brown,
                                                      child: Icon(
                                                        Icons.download,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),

                                            const Divider(),

                                            // Lab Name
                                            Row(
                                              children: [
                                                const Icon(Icons.business,
                                                    color: Colors.blue),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    sample.labName ?? 'N/A',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),

                                            // Location
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on,
                                                    color: Colors.blue),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    "${sample.villageName ?? 'N/A'}, "
                                                    "${sample.gramPanchayatName ?? 'N/A'}, "
                                                    "${sample.blockName ?? 'N/A'}, "
                                                    "${sample.districtName ?? 'N/A'}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'OpenSans',
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),

                                            const Divider(),

                                            // Test Result
                                            Row(
                                              children: [
                                                const Icon(Icons.category,
                                                    color: Colors.blue),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Test Result: ",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: sample
                                                                      .testResult ==
                                                                  "Report Approved"
                                                              ? Colors
                                                                  .green[100]
                                                              : sample.testResult ==
                                                                      "Under Process"
                                                                  ? Colors.yellow[
                                                                      100]
                                                                  : Colors.blue[
                                                                      100],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                        child: Text(
                                                          sample.testResult ??
                                                              'N/A',
                                                          style: TextStyle(
                                                            color: sample
                                                                        .testResult ==
                                                                    "Report Approved"
                                                                ? Colors
                                                                    .green[800]
                                                                : sample.testResult ==
                                                                        "Under Process"
                                                                    ? Colors.orange[
                                                                        800]
                                                                    : Colors.blue[
                                                                        800],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'OpenSans',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),

                                            const Divider(),

                                            // Date of Submission
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_today,
                                                    color: Colors.blue),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "Date of Submission: ${sample.sampleCollectionTime ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'OpenSans',
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}

enum SampleType {
  totalSampleSubmitted,
  totalPhysicalSubmitted,
  totalSampleTested,
  totalRetest
}
