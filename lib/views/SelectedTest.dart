import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:provider/provider.dart';

import '../providers/SampleSubProvider.dart';
import '../providers/masterProvider.dart';

class SelectedTestScreen extends StatefulWidget {
  const SelectedTestScreen({super.key});

  @override
  State<SelectedTestScreen> createState() => _SelectedTestScreenState();
}

class _SelectedTestScreenState extends State<SelectedTestScreen> {
  final TextEditingController remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final paramProvider =
    Provider.of<ParameterProvider>(context, listen: false);
    final masterProvider = Provider.of<Masterprovider>(context, listen: false);

    return ChangeNotifierProvider(
        create: (_) => Samplesubprovider(),
        child: Consumer<Samplesubprovider>(
            builder: (context, provider, child) {
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
                                color: Colors.white, // White background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  height: 250, // Fixed height
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical, // Enables vertical scrolling
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minWidth: MediaQuery.of(context).size.width,
                                                ),
                                                child: DataTable(
                                                  headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                  columnSpacing: MediaQuery.of(context).size.width * 0.05, // Dynamic spacing
                                                  columns: [
                                                    DataColumn(
                                                      label: Text('Sr. No.',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold)),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Test Name',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold)),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Price',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold)),
                                                    ),
                                                  ],
                                                  rows: paramProvider.cart!.asMap().entries.map((entry) {
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
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Total Price",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Text(
                                                "₹ 0 /-",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: remarkController,
                                    maxLines: 2, // Allows multiline input
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Better padding
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12), // Smoother rounded edges
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.blueAccent, width: 1.5), // Focus highlight
                                      ),
                                      hintText: "Enter your remarks",
                                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                      suffixIcon: remarkController.text.isNotEmpty
                                          ? IconButton(
                                        icon: Icon(Icons.clear, color: Colors.grey),
                                        onPressed: () {
                                          remarkController.clear(); // Clears text on click
                                        },
                                      )
                                          : null,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline, // Allows new line input
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Section 1: Lab Incharge Details
                                      Text(
                                        "Lab Incharge Details",
                                        style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey,
                                        ),
                                      ),
                                      Divider(thickness: 1, color: Colors.grey.shade300), // Divider for separation
                                      SizedBox(height: 8),

                                      Row(
                                        children: [
                                          Icon(Icons.person, color: Colors.blueAccent),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Name: ${paramProvider.labIncharge?.name ?? "N/A"}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      Row(
                                        children: [
                                          Icon(Icons.business, color: Colors.green),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Lab Name: ${paramProvider.labIncharge?.labName ?? "N/A"}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.redAccent),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Address: ${paramProvider.labIncharge?.address ?? "N/A"}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12), // Rounded corners
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3), // Shadow color
                                          blurRadius: 10, // Shadow blur
                                          offset: const Offset(0, 5), // Shadow position
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              'Latitude:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                              ),
                                              child: Text(
                                                "${provider.latitude}", // Display placeholder text if null
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black.withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ) ,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              'Longitude:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                              ),
                                              child: Text(
                                                "${provider.longitude}", // Display placeholder text if null
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black.withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 16),

                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20,),
                              ElevatedButton(
                                  onPressed: () {
                                    print('device id--->${provider.deviceId}');
                                    print('watersource id--->${masterProvider.waterSource}');
                                    var cartData= paramProvider.cart!.sublist(0,2).join(",");

                                    provider.sampleSubmit(
                                        int.parse(paramProvider.selectedLab
                                            .toString()),
                                        0,
                                        4,
                                        masterProvider.selectedDatetime,
                                        int.parse(masterProvider.selectedSubSource
                                            .toString()),
                                        int.parse(masterProvider
                                            .selectedWaterSource
                                            .toString()),
                                        int.parse(masterProvider.selectedStateId
                                            .toString()),
                                        int.parse(masterProvider.selectedDistrictId
                                            .toString()),
                                        int.parse(masterProvider.selectedBlockId
                                            .toString()),
                                        int.parse(masterProvider
                                            .selectedGramPanchayat
                                            .toString()),
                                        int.parse(masterProvider.selectedVillage
                                            .toString()),
                                        int.parse(masterProvider.selectedHabitation.toString()),
                                        int.parse(masterProvider.selectedWtsfilter.toString()),
                                        int.parse(masterProvider.selectedScheme.toString()),
                                        "",
                                        "", // source name
                                        provider.latitude,
                                        provider.longitude,
                                        remarkController.text,
                                        "mydeviceid",
                                        "",
                                        0,
                                        masterProvider.waterSource,
                                        "M");
                                  },
                                  child: Text(
                                    'Submit Sample',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF096DA8),
                                    // Button color
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 100.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  )),
                              SizedBox(height: 10),
                              Text(
                                "* Labs are not available with this combination (package)${paramProvider.cart!.length}",
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (provider.isLoading)
                        Container(
                          color: Colors.black.withOpacity(0.5), // Background opacity
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }));
  }
}




