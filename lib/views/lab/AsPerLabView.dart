import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';
import 'package:provider/provider.dart';

import '../../models/LabInchargeResponse/AllLabResponse.dart';
import '../../providers/masterProvider.dart';
import '../../services/LocalStorageService.dart';
import '../../utils/CustomSearchableDropdown.dart';
import '../../utils/LoaderUtils.dart';

class AsPerLabTabView extends StatefulWidget {
  @override
  _AsPerLabTabView createState() => _AsPerLabTabView();
}

class _AsPerLabTabView extends State<AsPerLabTabView> {
  late Masterprovider masterProvider;
  final LocalStorageService _localStorage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ParameterProvider>(context, listen: false).isLab=true;
    });
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
                    onPressed: () async{
                      await provider.fetchLocation();
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
                            child: const SubmitSampleScreen(),
                             // child: const SelectedTestScreenNew(),
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
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomSearchableDropdown(
                            title: "",
                            value: provider.selectedLab,
                            items: provider.labList
                                .map((lab) =>
                                    lab.text ?? '') // Display text, not value
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
                              provider.cart!.clear();
                              provider.setSelectedLab(selectedLab.text);
                              if (provider.isLabSelected) {
                                provider.fetchAllParameter(
                                  selectedLab.value!,
                                  masterProvider.selectedStateId ?? "0",
                                  "0",
                                  _localStorage.getString(AppConstants.prefRegId).toString(),
                                  "0",
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: provider.isLabSelected,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.all(5),
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
                                      value: provider.parameterType ?? 1,
                                      items: const [
                                        DropdownMenuItem(
                                            value: 1,
                                            child: Text('All Parameter')),
                                        DropdownMenuItem(
                                            value: 2,
                                            child: Text('Chemical Parameter')),
                                        DropdownMenuItem(
                                            value: 3,
                                            child: Text(
                                                'Bacteriological Parameter')),
                                      ],
                                      onChanged: (value) {
                                        if (value == null) return;
                                        provider.setParameterType(value);
                                        provider.cart!.clear();
                                        provider.fetchAllParameter(
                                          provider.selectedLab!,
                                          masterProvider.selectedStateId!,
                                          "0",
                                          _localStorage.getString(AppConstants.prefRegId).toString(),
                                          value.toString(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: provider.isLabSelected,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.all(5),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                              'Test Price',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: provider.parameterList.map((param) {
                                          bool isSelected = provider.cart!.any(
                                                (item) => item.parameterId == param.parameterId,
                                          );

                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                GestureDetector(
                                                  onTap: () {
                                                    provider.toggleCart(param);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                        value: isSelected,
                                                        onChanged: (bool? value) {
                                                          print('the selected value labview------- $value');
                                                          if (value != null) {
                                                            provider.toggleCart(param);
                                                          }
                                                        },
                                                      ),
                                                      SizedBox(width: 10),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          param.parameterName,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(fontSize: 14),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                GestureDetector(
                                                  onTap: () {
                                                    provider.toggleCart(param);
                                                  },
                                                  child: Text(
                                                    param.deptRate.toString(),
                                                    style: TextStyle(fontSize: 14),
                                                  ),
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

  Future<void> fetchLab(ParameterProvider paramProvider) async {
    paramProvider.parameterList.clear();
    paramProvider.parameterType = 1;
    paramProvider.cart!.clear();
    await paramProvider.fetchAllLabs(
        masterProvider.selectedStateId!,
        masterProvider.selectedDistrictId!,
        masterProvider.selectedBlockId!,
        masterProvider.selectedGramPanchayat!,
        masterProvider.selectedVillage!,
        "1");
  }
}
