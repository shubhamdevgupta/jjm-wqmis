import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';
import 'package:provider/provider.dart';

import '../../providers/ParameterProvider.dart';
import '../../utils/CustomDropdown.dart';

class Wtplabscreen extends StatefulWidget {
  @override
  _WtpLabScreen createState() => _WtpLabScreen();
}

class _WtpLabScreen extends State<Wtplabscreen> {
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
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.shopping_cart),
                  onPressed: () {
                    provider.fetchLocation();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(value: masterProvider),
                            ChangeNotifierProvider.value(value: provider),
                            // Pass parameterProvider if needed
                          ],
                          child: SubmitSampleScreen(),
                        ),
                      ),
                    );
                  }),
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text(
                  'Wtp Lab',
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
                          if (provider.cart!.isNotEmpty)
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
                                  child: SubmitSampleScreen(),
                                ),
                              ),
                            );
                          else
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
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF096DA8), // Dark blue
                          Color(0xFF3C8DBC),  // jjm blue color
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,// End at the bottom center
                      ),
                    ),
                  )
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomDropdown(
                            title: "Select WTP Lab *",
                            value: masterProvider.selectedWtpLab,
                            items: masterProvider.wtpLab.map((wtpLab) {
                              return DropdownMenuItem<String>(
                                value: wtpLab.labId,
                                child: Text(
                                  wtpLab.labName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              masterProvider.setSelectedWtpLab(value);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                                    'Parameter Type:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                            child: Text('Chemical Parameter')),
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
