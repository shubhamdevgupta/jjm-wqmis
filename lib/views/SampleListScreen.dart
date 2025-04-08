import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/SampleListProvider.dart';
import 'package:jjm_wqmis/utils/Strings.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/auth/DashboardScreen.dart';
import 'package:jjm_wqmis/views/DashboardScreen.dart';
import 'package:jjm_wqmis/views/testScreen/webview.dart';
import 'package:provider/provider.dart';

import '../providers/masterProvider.dart';
import '../services/LocalStorageService.dart';
import '../utils/Aesen.dart';
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
  int flag = 1; // Define flag
  final encryption = AesEncryption();
  @override
  void initState() {
    super.initState();
    getToken();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = _localStorage.getString("userId");
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      Masterprovider masterprovider = Provider.of<Masterprovider>(context, listen: false);
      Samplelistprovider sampleListProvider = Provider.of<Samplelistprovider>(context, listen: false);

      if (args != null) {
        int flag = args['flag'];

        if (flag == 0) {
          print("Fetching sample list with flag 0...");
          sampleListProvider.fetchSampleList(int.parse(userId!), 1, "0", 0, "0", 0, 0, 0, 0, 0);
        } else if (flag == 2) {
          print("Fetching sample list with flag 2...");
          sampleListProvider.fetchSampleList(int.parse(userId!), 1, "0", 2, "0", 0, 0, 0, 0, 0);
        } else if (flag == 6) {
          print("Fetching sample list with flag 6...");
          sampleListProvider.fetchSampleList(int.parse(userId!), 1, "0", 6, "0", 0, 0, 0, 0, 0);
        } else if (flag == 1) {
          print("Fetching sample list with selected location parameters...");
          sampleListProvider.fetchSampleList(
            int.parse(userId!),
            1,
            "0",
            0,
            "0",
            int.parse(masterprovider.selectedStateId!),
            int.parse(masterprovider.selectedDistrictId!),
            int.parse(masterprovider.selectedBlockId!),
            int.parse(masterprovider.selectedGramPanchayat!),
            int.parse(masterprovider.selectedVillage!),
          );
        } else {
          print("Fetching default sample list...");
          sampleListProvider.fetchSampleList(int.parse(userId!), 1, "0", 0, "0", 0, 0, 0, 0, 0);
        }
      } else {
        print("Fetching default sample list...");
        sampleListProvider.fetchSampleList(int.parse(userId!), 1, "0", 0, "0", 0, 0, 0, 0, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/header_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboardscreen()),
                        (route) => false, // Removes all previous routes
                  );              }
              },
            ),
            title: const Text(Strings.appTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
            elevation: 5,
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
                      child: Locationscreen(flag: flag,),
                    ),
                  );
                },
              );
      
            },
            backgroundColor: Color(0xFF0468B1),
            shape: CircleBorder(),
            elevation: 4,
            child: Padding(
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
                  SizedBox(height: 20),
      
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0468B1),
                            textStyle: TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // less = more squared
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14), // optional: adjust size
                          ),
                          onPressed: () {
                            if (searchController.text.isNotEmpty) {
                              provider.fetchSampleList(int.parse(userId!), 1, "",
                                  0, searchController.text, 0, 0, 0, 0, 0);
                            } else {
                              ToastHelper.showErrorSnackBar(
                                  context, "Please enter sample id");
                            }
                          },
                          child: Text(
                            "Search",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
      
                  // Expanded to prevent infinite height issue
                  Expanded(
                    child: provider.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : provider.samples.isEmpty
                            ? Center(child: Text("No data available"))
                            : ListView.builder(
                                itemCount: provider.samples.length,
                                itemBuilder: (context, index) {
                                  var sample = provider.samples[index];
      
                                  return Card(
                                    margin: EdgeInsets.symmetric(
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
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // ID Row
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  child: Text(
                                                    "${index + 1}",
                                                    style: TextStyle(
                                                      color: Colors.white,
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
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(
                                                      builder: (_) => MyWebView(url: 'https://ejalshakti.gov.in/WQMIS/Common/final_report_print?s_id=${encryption..encryptText(sample.sampleId!)}'),
                                                    ),
                                                    );
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.brown,
                                                    child: Icon(Icons.download,color: Colors.white,),

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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: sample.testResult == "Report Approved"
                                                              ? Colors.green[100]
                                                              : sample.testResult == "Under Process"
                                                              ? Colors.yellow[100]
                                                              : Colors.blue[100],
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        child: Text(
                                                          sample.testResult ?? 'N/A',
                                                          style: TextStyle(
                                                            color: sample.testResult == "Report Approved"
                                                                ? Colors.green[800]
                                                                : sample.testResult == "Under Process"
                                                                ? Colors.orange[800]
                                                                : Colors.blue[800],
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
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

  String getToken() {
    String? token = _localStorage.getString('token') ?? '';
    userId = _localStorage.getString('userId') ?? '';
    return token;
  }
}
