import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/parameter_provider.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/dept_data/submit_sample_screen.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/models/LabInchargeResponse/allLab_response.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_searchable_dropdown.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';

class AsPerLabTabView extends StatefulWidget {
  const AsPerLabTabView({super.key});

  @override
  _AsPerLabTabView createState() => _AsPerLabTabView();
}

class _AsPerLabTabView extends State<AsPerLabTabView> {
  late Masterprovider masterProvider;
  final session = UserSessionManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await session.init();
      masterProvider = Provider.of<Masterprovider>(context, listen: false);

      Provider.of<ParameterProvider>(context, listen: false).isLab=true;
      Provider.of<ParameterProvider>(context, listen: false).isParam=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<ParameterProvider>(context, listen: false),
      child: Consumer<ParameterProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
              :Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FloatingActionButton(
                      onPressed: () async{
                        if (provider.cart!.isNotEmpty) {
                          provider.fetchLabIncharge(int.parse(provider.selectedLab!),session.regId);
                          provider.isLab=true;
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
                              color: Colors.white, fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                            CustomSearchableDropdown(
                              title: 'Select Laboratory',
                              value: provider.labList.firstWhere((lab) => lab.value == provider.selectedLab,
                                orElse: () => AllLabResponse(value: null, text: null),
                              ).text,
                              items: provider.labList.map((lab) => lab.text ?? '').toList(),
                              onChanged: (selectedLabText) {
                                if (selectedLabText == null) {
                                  return; // Handle null case
                                }

                                final selectedLab = provider.labList.firstWhere(
                                      (lab) => lab.text == selectedLabText,
                                  orElse: () => AllLabResponse(
                                      value: null,
                                      text:
                                      null), // Default to a nullable object
                                );
                                provider.cart!.clear();
                                provider.setSelectedLab(selectedLab.value);
                                if (provider.isLabSelected) {
                                  provider.fetchAllParameter(
                                    selectedLab.value!,
                                    masterProvider.selectedStateId ?? "0",
                                    "0",
                                    session.regId.toString(),
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
                                margin: const EdgeInsets.all(5),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Select Parameter Type:',
                                        style: TextStyle( fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      DropdownButton<int>(
                                        isExpanded: true,
                                        value: provider.parameterType,
                                        items: const [
                                          DropdownMenuItem(
                                              value: 1,
                                              child: Text('All Parameter',style: TextStyle( fontFamily: 'OpenSans',fontWeight: FontWeight.w400,fontSize: 15),)),
                                          DropdownMenuItem(
                                              value: 2,
                                              child: Text('Chemical Parameter',style: TextStyle( fontFamily: 'OpenSans',fontWeight: FontWeight.w400,fontSize: 15),)),
                                          DropdownMenuItem(
                                              value: 3,
                                              child: Text(
                                                'Bacteriological Parameter',style: TextStyle( fontFamily: 'OpenSans',fontWeight: FontWeight.w400,fontSize: 15),)),
                                        ],
                                        onChanged: (value) {
                                          if (value == null) return;
                                          provider.setParameterType(value);
                                          provider.cart!.clear();
                                          provider.fetchAllParameter(
                                            provider.selectedLab!,
                                            masterProvider.selectedStateId!,
                                            "0",
                                            session.regId.toString(),
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
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
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
                                                    fontWeight: FontWeight.bold, fontFamily: 'OpenSans',
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontFamily: 'OpenSans',
                                                    fontSize: 16,
                                                    color: Colors.black,
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
                                                              if (value != null) {
                                                                provider.toggleCart(param);
                                                              }
                                                            },
                                                          ),
                                                          const SizedBox(width: 10),
                                                          SizedBox(
                                                            width: 150,
                                                            child: Text(
                                                              param.parameterName,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(fontSize: 14, fontFamily: 'OpenSans',),
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
                                                        style: const TextStyle(fontSize: 14, fontFamily: 'OpenSans',),
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
                                          'Selected Param: ${provider.cart!.length}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
        "1",session.regId);
  }
}