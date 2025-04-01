import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:provider/provider.dart';

import '../../providers/masterProvider.dart';
import '../SelectedTest.dart';

class Asperparameterview extends StatefulWidget {
  @override
  State<Asperparameterview> createState() => _AsperparameterviewState();
}

class _AsperparameterviewState extends State<Asperparameterview> {
  late Masterprovider masterProvider;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
  
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<ParameterProvider>(context, listen: false),
      child: Consumer<ParameterProvider>(
        builder: (context, provider, child) {
          return Container(
            child: Scaffold(
              floatingActionButton: Stack(
                clipBehavior: Clip.none,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      print('selected labb   ${provider.selectedLab}');
                      if (provider.cart!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider.value(
                                    value: masterProvider),
                                ChangeNotifierProvider.value(value: provider),
                              ],
                              child: const SelectedTestScreen(),
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
              body: Card(
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

                      // ✅ Wrapping in Expanded & SingleChildScrollView
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
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
            ),
          );
        },
      ),
    );
  }
}
