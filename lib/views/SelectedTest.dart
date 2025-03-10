import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/LabInchargeResponse.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/ParameterResponse.dart';

class SelectedTestScreen extends StatelessWidget {
  final List<Parameterresponse>? cartList;
  final TextEditingController remarkController = TextEditingController();
  final Labinchargeresponse? labinchargeresponse;

  SelectedTestScreen(
      {required this.cartList, required this.labinchargeresponse});

  @override
  Widget build(BuildContext context) {
    print("------------>>>>>>>> $labinchargeresponse");
    print("------------>>>>>>>> $cartList");
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity, // Ensures full width
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width),
                              child: DataTable(
                                headingRowColor:
                                    MaterialStateProperty.all(Colors.blue),
                                columnSpacing:
                                    MediaQuery.of(context).size.width *
                                        0.05, // Dynamic spacing
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
                                rows: cartList!.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var param = entry.value;
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text('${index + 1}',
                                          style: TextStyle(fontSize: 14))),
                                      DataCell(SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4, // Dynamic width
                                        child: Text(
                                          param.parameterName,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      )),
                                      DataCell(Text(param.deptRate.toString(),
                                          style: TextStyle(fontSize: 14))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Total Price",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20),
                              Text(
                                "₹ 0 /-",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: TextFormField(
                            controller: remarkController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              hintText: "Enter your remarks",
                              hintStyle: const TextStyle(fontSize: 16),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Text('Name: ${labinchargeresponse?.name ?? "N/A"}', style: const TextStyle(fontSize: 16),),
                            Text('Lab Name: ${labinchargeresponse?.labName ?? "N/A"}', style: const TextStyle(fontSize: 16),),
                            Text('Address: ${labinchargeresponse?.address ?? "N/A"}', style: const TextStyle(fontSize: 16),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(onPressed: (){}, child: Text('Submit Sample',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF096DA8), // Button color
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "* Labs are not available with this combination (package)${cartList!.length}",
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
