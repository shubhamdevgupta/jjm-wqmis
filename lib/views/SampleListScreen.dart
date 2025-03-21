import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jjm_wqmis/providers/SampleListProvider.dart';
import 'package:jjm_wqmis/utils/CustomTextField.dart';
import 'package:provider/provider.dart';

import '../services/LocalStorageService.dart';
import 'LocationScreen.dart';

class SampleListScreen extends StatefulWidget {
  @override
  _SampleListScreenState createState() => _SampleListScreenState();
}

class _SampleListScreenState extends State<SampleListScreen> {
  final LocalStorageService _localStorage = LocalStorageService();

  bool isLoading = false;

  List<Map<String, dynamic>> filteredList = []; // Filtered list for search
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? userId = _localStorage.getString("userId");
      Provider.of<Samplelistprovider>(context, listen: false)
          .fetchSampleList(int.parse(userId!), 1, "", 0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'JJM-WQMIS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  // Drawer icon
                  onPressed: () {
                    Scaffold.of(context)
                        .openDrawer(); // Open the Navigation Drawer
                  },
                );
              },
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF096DA8), // Dark blue color
                    Color(0xFF3C8DBC), // Green color
                  ],
                  begin: Alignment.topCenter, // Start at the top center
                  end: Alignment.bottomCenter, // End at the bottom center
                ),
              ),
            ),
            elevation: 5,
          ),
          body:
              Consumer<Samplelistprovider>(builder: (context, provider, child) {
            return Stack(children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CustomTextField(
                              labelText: "Search", hintText: 'Search..'),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0468B1),
                              textStyle: TextStyle(fontSize: 16),
                              // Set a minimum width (200) and height (50)
                            ),
                            onPressed: () {},
                            child: Text(
                              "Search",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: provider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : provider.samples.isEmpty
                              ? Center(child: Text("No data available"))
                              : ListView.builder(
                                 shrinkWrap: true,
                                   physics: NeverScrollableScrollPhysics(),
                                 itemCount: provider.samples.length,
                                 itemBuilder: (context, index) {
                          var sample = provider.samples[index];

                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "ID: ${provider.samples. ?? 'N/A'}",
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            sample. ?? 'N/A',
                                            style:
                                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    Divider(),
                                    Row(
                                      children: [
                                        Icon(Icons.business, color: Colors.blue),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            sample.lab_name ?? 'N/A',
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),

                                    Row(
                                      children: [
                                        Icon(Icons.location_on, color: Colors.blue),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            "${sample.VillageName}, ${sample.GramPanchayatName}, ${sample.BlockName}, ${sample.DistrictName}",
                                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),

                                    Divider(),
                                    Row(
                                      children: [
                                        Icon(Icons.category, color: Colors.blue),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Test Result: ",
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: sample.test_result == 'Report Approved'
                                                      ? Colors.green[100]
                                                      : Colors.blue[100],
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: Text(
                                                  sample.test_result ?? 'N/A',
                                                  style: TextStyle(
                                                    color: sample.test_result == 'Report Approved'
                                                        ? Colors.green[800]
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
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Colors.blue),
                                        SizedBox(width: 5),
                                        Text(
                                          "Date of Submission: ${sample.sample_collection_time ?? 'N/A'}",
                                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                      ,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20, // Adjust as needed
                right: 20, // Adjust as needed
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        double screenHeight =
                            MediaQuery.of(context).size.height;
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(10),
                          content: Container(
                            color: Colors.white,
                            height: screenHeight * 0.8,
                            width: screenHeight * 0.4,
                            child: Locationscreen(),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0468B1),
                    shape: CircleBorder(),
                    // Makes the button fully circular
                    padding: EdgeInsets.all(16), // Ensures better touch area
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24, // Adjust size if needed
                  ),
                ),
              ),
            ]);
          })),
    );
  }
}
