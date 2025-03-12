
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/views/SelectedTest.dart';
import 'package:provider/provider.dart';

import '../providers/ParameterProvider.dart';
import '../utils/CustomDropdown.dart';

class Labparameterscreen extends StatefulWidget {
  @override
  _LabParameterScreen createState() => _LabParameterScreen();
}

class _LabParameterScreen extends State<Labparameterscreen> {
  late Masterprovider masterProvider;
  @override
  void initState() {
    super.initState();
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParameterProvider(),
      child: Consumer<ParameterProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text(
                  'Select Lab/Parameter',
                  style: TextStyle(color: Colors.white),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/savesample');
                    }                  },
                ),
                backgroundColor: Colors.blueAccent, // Consistent theme
                actions: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart,
                            color: Colors.white),
                        // Cart icon
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider.value(value: masterProvider), // Pass masterProvider
                                  ChangeNotifierProvider.value(value: provider), // Pass parameterProvider if needed
                                ],
                                child: SelectedTestScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      if (provider.cart!
                          .isNotEmpty) // Show badge only when cart is not empty
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${provider.cart!.length}',
                              // Show count dynamically
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            // Increased elevation for a more modern shadow effect
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Slightly increased border radius for a smooth look
                            ),
                            margin: EdgeInsets.all(5),
                            // Margin to ensure spacing around the card
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select lab where sample has been taken:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                          value: 1,
                                          groupValue: provider.selectionType,
                                          onChanged: (value) => {
                                                provider.parameterList.clear(),
                                                provider.parameterType=0,
                                                provider.cart!.clear(),
                                                provider.fetchAllLabs(masterProvider.selectedStateId!,masterProvider.selectedDistrictId!,masterProvider.selectedBlockId!,masterProvider.selectedGramPanchayat!,masterProvider.selectedVillage!,"1"),
                                                provider.setSelectionType(value!),
                                              }),
                                      const Text('As per laboratory'),
                                      Radio(
                                          value: 2,
                                          groupValue: provider.selectionType,
                                          onChanged: (value) => {
                                                provider.labIncharge=null,
                                                provider.parameterType=0,
                                                provider.cart!.clear(),
                                            provider.setSelectionType(value!),
                                            if(value==2){
                                              provider.fetchAllParameter("0",masterProvider.selectedStateId!, "0", "1151455", "1"),
                                            }
                                              }),
                                      const Text('As per parameters'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (provider.selectionType == 1) ...[
                            CustomDropdown(
                              title: "Select Lab *",
                              value: provider.selectedLab,
                              items: provider.labList.map((labId) {
                                return DropdownMenuItem<String>(
                                    value: labId.value,
                                    child: Text(
                                      labId.text,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                provider.setSelectedLab(value);
                                if(value!=null){
                                  provider.fetchAllParameter(
                                      provider.selectedLab!,
                                      masterProvider.selectedStateId!,
                                      "0",
                                      "1151455",
                                      "0");
                                }
                              },
                            )
                          ],
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: provider.selectionType == 1,
                            child: Card(
                              elevation: 5,
                              // Increased elevation for a more modern shadow effect
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Slightly increased border radius for a smooth look
                              ),
                              margin: EdgeInsets.all(5),
                              // Margin to ensure spacing around the card
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Select Parameter Type:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton<int>(
                                        isExpanded: true,
                                        value: provider.parameterType,
                                        items: [
                                          const DropdownMenuItem(
                                              value: 0,
                                              child: Text('Select Parameter'))  ,
                                          const DropdownMenuItem(
                                              value: 1,
                                              child: Text('All Parameter')),
                                          const DropdownMenuItem(
                                              value: 2,
                                              child:
                                                  Text('Chemical Parameter')),
                                          const DropdownMenuItem(
                                              value: 3,
                                              child: Text(
                                                  'Bacteriological Parameter')),
                                        ],
                                        onChanged: (value) => {
                                          provider.setParameterType(value!),
                                          if(value!=0){
                                            provider.fetchAllParameter(provider.selectedLab!, masterProvider.selectedStateId!, "0", "1151455", value.toString()),
                                          }

                                        }

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: provider.parameterType==1|| provider.parameterType==2|| provider.parameterType==3||provider.selectionType==2,
                            child: Card(
                              elevation: 5,
                              // Increased elevation for a modern shadow effect
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners for a smooth look
                              ),
                              margin: EdgeInsets.all(5),
                              // Margin around the card
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                // Adjusted padding for better spacing
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tests Available:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        // Increased font size for better readability
                                        color: Colors
                                            .blueAccent, // Added color for better emphasis
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    // Added more space between title and table
                                    SingleChildScrollView(
                                      // Horizontal scrolling for "Test Name"
                                      scrollDirection: Axis.horizontal,
                                      // Enable horizontal scroll
                                      child: DataTable(
                                        columnSpacing: 20,
                                        // Increased column spacing for better clarity
                                        headingRowHeight: 50,
                                        // Increased heading row height for a clean look
                                        dataRowHeight: 60,
                                        // Increased data row height for better readability
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'Sr. No.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                // Font size adjustment for column headers
                                                color: Colors
                                                    .blueGrey, // Change the color for headers
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Test Name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Test Price',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Select Test',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: provider.parameterList
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          var param = entry.value;
                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text('${index + 1}',
                                                  style:
                                                      TextStyle(fontSize: 14))),
                                              DataCell(SizedBox(
                                                width: 150,
                                                // Giving more space for the test name to show
                                                child: Text(
                                                  param.parameterName,
                                                  overflow: TextOverflow.ellipsis,
                                                  // To handle overflow
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              )),
                                              DataCell(Text(
                                                  param.deptRate.toString(),
                                                  style:
                                                      TextStyle(fontSize: 14))),
                                              DataCell(
                                                Checkbox(
                                                  value: provider.cart!.any(
                                                      (item) =>
                                                          item.parameterIdAlt ==
                                                          param.parameterIdAlt),
                                                  onChanged: (bool? value) {
                                                    if (value != null) {
                                                      provider.toggleCart(param);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Cart: ${provider.cart!.join(', ')}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

