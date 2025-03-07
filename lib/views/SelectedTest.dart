import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/ParameterResponse.dart';
import 'package:provider/provider.dart';

import '../providers/ParameterProvider.dart';
import '../utils/Appcolor.dart';
import '../utils/CustomDropdown.dart';


class SelectedTestScreen extends StatelessWidget {
  final List<Parameterresponse> cartList;

  SelectedTestScreen({required this.cartList});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
            },
          ),
          title: const Text(
            'Selected Test',
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              // Background color for the container
              borderRadius: BorderRadius.circular(8),
              // Rounded corners
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF096DA8), // Dark blue color
                  Color(0xFF3C8DBC), // jjm blue color
                ],
                begin: Alignment.topCenter, // Start at the top center
                end: Alignment.bottomCenter, // End at the bottom center
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity, // Ensures full width
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(Colors.blue),
                                    columnSpacing: MediaQuery.of(context).size.width * 0.05, // Dynamic spacing
                                    columns: [
                                      DataColumn(
                                        label: Text('Sr. No.',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ),
                                      DataColumn(
                                        label: Text('Test Name',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ),
                                      DataColumn(
                                        label: Text('Price',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                    rows: cartList.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      var param = entry.value;
                                      return DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('${index + 1}', style: TextStyle(fontSize: 14))),
                                          DataCell(SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.4, // Dynamic width
                                            child: Text(
                                              param.parameterName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          )),
                                          DataCell(Text(param.deptRate.toString(), style: TextStyle(fontSize: 14))),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total Price",
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "₹ 0 /-",
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 10),
                    Text(
                      "* Labs are not available with this combination (package)${cartList.length}",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TableWidget extends StatelessWidget {
  final List<Map<String, String>> testData = [
    {"Sr. No.": "1", "Test Name": "Alachlor", "Price": "₹ 0.00"},
    {"Sr. No.": "2", "Test Name": "Aluminum (As Al)", "Price": "₹ 0.00"},
    {
      "Sr. No.": "3",
      "Test Name": "Ammonia (as Total Ammonia- N)",
      "Price": "₹ 0.00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.blue),
                columnSpacing: 20,
                columns: [
                  DataColumn(
                    label: Text('Sr. No.',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Test Name',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Price',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
                rows: testData.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item["Sr. No."]!)),
                    DataCell(Text(item["Test Name"]!)),
                    DataCell(Text(item["Price"]!)),
                  ]);
                }).toList(),
              ),
            ),
            Divider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total Price",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "₹ 0 /-",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
