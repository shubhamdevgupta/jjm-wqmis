import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:provider/provider.dart';

import '../../models/LabInchargeResponse/AllLabResponse.dart';
import '../../providers/masterProvider.dart';
import '../../utils/CustomSearchableDropdown.dart';
import '../../utils/LoaderUtils.dart';
import '../../utils/toast_helper.dart';
import '../SelectedTest.dart';

class AsPerLabTabView extends StatefulWidget {
  @override
  _AsPerLabTabView createState() => _AsPerLabTabView();
}

class _AsPerLabTabView extends State<AsPerLabTabView> {
  late Masterprovider masterProvider;
  late ParameterProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
    provider = Provider.of<ParameterProvider>(context, listen: false);

    /*setState(() {
      provider.parameterList.clear();
      provider.parameterType = 0;
      provider.cart!.clear();
      provider.fetchAllLabs(
          masterProvider.selectedStateId!,
          masterProvider.selectedDistrictId!,
          masterProvider.selectedBlockId!,
          masterProvider.selectedGramPanchayat!,
          masterProvider.selectedVillage!,
          "1");
      provider.setSelectionType(1);
    });*/
    Future.microtask(() {
      provider = Provider.of<ParameterProvider>(context, listen: false);
      provider.updateSomeValue(
        masterProvider.selectedStateId!,
        masterProvider.selectedDistrictId!,
        masterProvider.selectedBlockId!,
        masterProvider.selectedGramPanchayat!,
        masterProvider.selectedVillage!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParameterProvider(),
      child: Consumer<ParameterProvider>(
        builder: (context, provider, child) {
          return Container(
            child: Scaffold(
              floatingActionButton: Stack(
                clipBehavior: Clip.none,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      await provider.fetchLocation();
                      print(
                          '-------2222222${provider.currentPosition!.latitude}');
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
                            margin: const EdgeInsets.all(5),
                            // Margin to ensure spacing around the card
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  TextButton(
                                      onPressed: () => {
                                            provider.parameterList.clear(),
                                            provider.parameterType = 0,
                                            provider.cart!.clear(),
                                            provider.fetchAllLabs(
                                                masterProvider.selectedStateId!,
                                                masterProvider
                                                    .selectedDistrictId!,
                                                masterProvider.selectedBlockId!,
                                                masterProvider
                                                    .selectedGramPanchayat!,
                                                masterProvider.selectedVillage!,
                                                "1"),
                                            provider.setSelectionType(1),
                                          },
                                      child: const Text(
                                        "Click Me",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
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
                          const SizedBox(
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
                                        items: const [
                                          DropdownMenuItem(
                                              value: 0,
                                              child: Text('Select Parameter')),
                                          DropdownMenuItem(
                                              value: 1,
                                              child: Text('All Parameter')),
                                          DropdownMenuItem(
                                              value: 2,
                                              child:
                                                  Text('Chemical Parameter')),
                                          DropdownMenuItem(
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
                          const SizedBox(
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
                                      style: const TextStyle(
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
