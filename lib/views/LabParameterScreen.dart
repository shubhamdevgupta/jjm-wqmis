import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/SelectedTest.dart';
import 'package:provider/provider.dart';

import '../models/LabInchargeResponse/AllLabResponse.dart';
import '../providers/ParameterProvider.dart';
import '../utils/CustomSearchableDropdown.dart';

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
              floatingActionButton: Stack(
                clipBehavior: Clip.none,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      await provider.fetchLocation();
                      print('-------2222222${provider.currentPosition!.latitude}');
                      if (provider.cart!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider.value(value: masterProvider),
                                ChangeNotifierProvider.value(value: provider),
                              ],
                              child: SelectedTestScreen(),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a test."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Icon(Icons.shopping_cart),
                  ),

                  // Cart Badge - Show if cart is not empty
                  if (provider.cart!.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${provider.cart!.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
                    }
                  },
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
                          if (provider.cart!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider.value(
                                        value: masterProvider),
                                    // Pass masterProvider
                                    ChangeNotifierProvider.value(
                                        value: provider),
                                    // Pass parameterProvider if needed
                                  ],
                                  child: SelectedTestScreen(),
                                ),
                              ),
                            );
                          } else
                            ToastHelper.showErrorSnackBar(
                                context, "Please Select Test");
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
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                              value: 1,
                                              groupValue:
                                                  provider.selectionType,
                                              onChanged: (value) => {
                                                    provider.parameterList
                                                        .clear(),
                                                    provider.parameterType = 0,
                                                    provider.cart!.clear(),
                                                    provider.fetchAllLabs(
                                                        masterProvider
                                                            .selectedStateId!,
                                                        masterProvider
                                                            .selectedDistrictId!,
                                                        masterProvider
                                                            .selectedBlockId!,
                                                        masterProvider
                                                            .selectedGramPanchayat!,
                                                        masterProvider
                                                            .selectedVillage!,
                                                        "1"),
                                                    provider.setSelectionType(
                                                        value!),
                                                  }),
                                          const Text('As per laboratory'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                              value: 2,
                                              groupValue:
                                                  provider.selectionType,
                                              onChanged: (value) => {
                                                    provider.labIncharge = null,
                                                    provider.parameterType = 0,
                                                    provider.cart!.clear(),
                                                    provider.setSelectionType(
                                                        value!),
                                                    if (value == 2)
                                                      {
                                                        provider.fetchAllParameter(
                                                            "0",
                                                            masterProvider
                                                                .selectedStateId!,
                                                            "0",
                                                            "1151455",
                                                            "1"),
                                                      }
                                                  }),
                                          const Text('As per parameters'),
                                        ],
                                      )
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
                            CustomSearchableDropdown(
                              title: "Select Lab *",
                              value: provider.selectedLab,
                              items: provider.labList
                                  .map((lab) => lab.text ?? '')
                                  .toList(),
                              onChanged: (selectedLabText) {
                                if (selectedLabText == null)
                                  return; // Handle null case

                                final selectedLab = provider.labList.firstWhere(
                                  (lab) => lab.text == selectedLabText,
                                  orElse: () => Alllabresponse(
                                      value: null,
                                      text:
                                          null), // Default to a nullable object
                                );
                                provider.setSelectedLab(selectedLab.value);
                                if (selectedLab.value != null) {
                                  provider.fetchAllParameter(
                                    selectedLab.value!,
                                    masterProvider.selectedStateId ?? "0",
                                    "0",
                                    "1151455",
                                    "0",
                                  );
                                }
                              },
                            ),
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
                                              child: Text('Select Parameter')),
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
                                              if (value != 0)
                                                {
                                                  provider.fetchAllParameter(
                                                      provider.selectedLab!,
                                                      masterProvider
                                                          .selectedStateId!,
                                                      "0",
                                                      "1151455",
                                                      value.toString()),
                                                }
                                            }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: provider.parameterType == 1 ||
                                provider.parameterType == 2 ||
                                provider.parameterType == 3 ||
                                provider.selectionType == 2,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.all(5),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tests Available:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: 20,
                                        headingRowHeight: 50,
                                        dataRowHeight: 60,
                                        columns: const <DataColumn>[
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
                                        ],
                                        rows:
                                            provider.parameterList.map((param) {
                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Checkbox(
                                                  value: provider.cart!.any(
                                                    (item) =>
                                                        item.parameterId ==
                                                        param.parameterId,
                                                  ),
                                                  onChanged: (bool? value) {
                                                    if (value != null) {
                                                      provider
                                                          .toggleCart(param);
                                                    }
                                                  },
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                    param.parameterName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  param.deptRate.toString(),
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Cart: ${provider.cart!.length}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                  if (provider.isLoading)
                    LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
