import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:provider/provider.dart';

class SelectedTestScreen extends StatelessWidget {
  final TextEditingController remarkController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ParameterProvider>(context, listen: false);

    print("------------>>>>>>>> ${provider.labIncharge}");
    print("------------>>>>>>>> ${provider.cart}");
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
        body: SingleChildScrollView(
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
                                    rows: provider.cart!.asMap().entries.map((entry) {
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
                                'Name: ${provider.labIncharge?.name ?? "N/A"}',
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
                                'Lab Name: ${provider.labIncharge?.labName ?? "N/A"}',
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
                                'Address: ${provider.labIncharge?.address ?? "N/A"}',
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
                                 "28.00000", // Display placeholder text if null
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
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
                                  "72.5200", // Display placeholder text if null
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
                ElevatedButton(onPressed: (){}, child: Text('Submit Sample',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF096DA8), // Button color
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                    )
                ),
                SizedBox(height: 10),
                Text(
                  "* Labs are not available with this combination (package)${provider.cart!.length}",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
