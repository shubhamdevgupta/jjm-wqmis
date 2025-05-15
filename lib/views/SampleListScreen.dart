import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/SampleListProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/auth/DashboardScreen.dart';
import 'package:jjm_wqmis/views/webView/testReport.dart';
import 'package:provider/provider.dart';

import '../models/SampleListResponse.dart';
import '../providers/masterProvider.dart';
import '../services/LocalStorageService.dart';
import '../utils/Aesen.dart';
import '../utils/AppStyles.dart';
import '../utils/DataState.dart';
import '../utils/Showerrormsg.dart';
import 'LocationScreen.dart';

class SampleListScreen extends StatefulWidget {
  @override
  _SampleListScreenState createState() => _SampleListScreenState();
}

class _SampleListScreenState extends State<SampleListScreen> {
  final LocalStorageService _localStorage = LocalStorageService();
  String? userId = '';
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
          title: Text('Select Year'),
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
    getToken();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = _localStorage.getString("userId");

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

        if ((flagfloation == AppConstants.totalSamplesSubmitted ||
                flag == AppConstants.openSampleListScreen) &&
            (flagfloation == AppConstants.totalPhysicalSubmitted ||
                flag == AppConstants.openSampleListScreen) &&
            (flag == AppConstants.openSampleListScreen ||
                flagfloation == AppConstants.totalSampleTested)) {
          if (flagfloation == AppConstants.totalSamplesSubmitted) {
            C_STATUS = 1;
          } else if (flagfloation == AppConstants.totalPhysicalSubmitted) {
            C_STATUS = 2;
          } else if (flagfloation == AppConstants.totalSampleTested) {
            C_STATUS = 6;
          }
          sampleListProvider.fetchSampleList(
              int.parse(userId!),
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
          sampleListProvider.fetchSampleList(int.parse(userId!), PAGE, SEARCH,
              C_STATUS, SAMPLE_ID, 0, 0, 0, 0, 0);
        } else if (flag == AppConstants.totalSampleTested ||
            flag == AppConstants.openSampleListScreen) {
          sampleListProvider.fetchSampleList(
              int.parse(userId!), 1, "0", 6, "0", 0, 0, 0, 0, 0);
        } else if (flag == AppConstants.totalSamplesSubmitted ||
            flag == AppConstants.openSampleListScreen) {
          C_STATUS = 1;
          sampleListProvider.fetchSampleList(int.parse(userId!), PAGE, SEARCH,
              C_STATUS, SAMPLE_ID, 0, 0, 0, 0, 0);
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
          '/dashboard',
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
                    MaterialPageRoute(builder: (context) => Dashboardscreen()),
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
                    contentPadding: EdgeInsets.all(10),
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
            backgroundColor: Color(0xFF0468B1),
            shape: CircleBorder(),
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
              switch (provider.dataState) {
                case DataState.initial:
                  return const Center(
                      child: Text("Please wait..."));
                case DataState.loading:
                  return Center(
                      child: LoaderUtils.conditionalLoader(isLoading: true));
                case DataState.loadedEmpty:
                case DataState.loaded:

                  return Column(
                    children: [
                      SizedBox(height: 20),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child:  TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: AppStyles.buttonStylePrimary(
                                  backgroundColor: const Color(0xFF0468B1),
                                  fontSize: 16,
                                  borderRadius: 6,
                                  horizontalPadding: 20,
                                  verticalPadding: 14),
                              onPressed: () {
                                print("------------ ${searchController.text}");
                                if (searchController.text.isNotEmpty) {
                                  provider.fetchSampleList(
                                      int.parse(userId!),
                                      1,
                                      "",
                                      0,
                                      searchController.text,
                                      0,
                                      0,
                                      0,
                                      0,
                                      0);
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

                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.samples.length,
                          itemBuilder: (context, index) {
                            Sample sample = provider
                                .samples[index]; // where result is List<Sample>

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ID Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Text(
                                              "${index + 1}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          //SizedBox(width: 10),

                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "ID: ${sample.sampleId ?? 'N/A'}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          Visibility(
                                            visible: sample.testResult ==
                                                "Report Approved",
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => TestReport(
                                                        url:
                                                            'https://ejalshakti.gov.in/WQMIS/Common/final_report_print?s_id=${encryption.encryptText(sample.sId.toString())}'),
                                                  ),
                                                );
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.brown,
                                                child: Icon(
                                                  Icons.download,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      Divider(),

                                        // Lab Name
                                        Row(
                                          children: [
                                            Icon(Icons.business,
                                                color: Colors.blue),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                sample.labName ?? 'N/A',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),

                                        // Location
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                color: Colors.blue),
                                            SizedBox(width: 5),
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
                                        SizedBox(height: 8),

                                        Divider(),

                                        // Test Result
                                        Row(
                                          children: [
                                            Icon(Icons.category,
                                                color: Colors.blue),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Test Result: ",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: sample
                                                                  .testResult ==
                                                              "Report Approved"
                                                          ? Colors.green[100]
                                                          : sample.testResult ==
                                                                  "Under Process"
                                                              ? Colors
                                                                  .yellow[100]
                                                              : Colors
                                                                  .blue[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Text(
                                                      sample.testResult ??
                                                          'N/A',
                                                      style: TextStyle(
                                                        color: sample
                                                                    .testResult ==
                                                                "Report Approved"
                                                            ? Colors.green[800]
                                                            : sample.testResult ==
                                                                    "Under Process"
                                                                ? Colors
                                                                    .orange[800]
                                                                : Colors
                                                                    .blue[800],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        fontFamily: 'OpenSans',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),

                                        Divider(),

                                        // Date of Submission
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today,
                                                color: Colors.blue),
                                            SizedBox(width: 5),
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
                case DataState.error:
                  return Center(
                    child: AppTextWidgets.errorText(provider.errorMsg),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  String getToken() {
    String? token = _localStorage.getString(AppConstants.prefToken) ?? '';
    userId = _localStorage.getString(AppConstants.prefUserId) ?? '';
    return token;
  }
}

enum SampleType {
  totalSampleSubmitted,
  totalPhysicalSubmitted,
  totalSampleTested,
  totalRetest
}
