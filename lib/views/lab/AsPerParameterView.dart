import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';

class Asperparameterview extends StatefulWidget {
  const Asperparameterview({super.key});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ParameterProvider>(context, listen: false).isLab = false;
      Provider.of<ParameterProvider>(context, listen: false).isParam = true;
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
                    onPressed: () async {
                      provider.selectedLab = '';
                      provider.labList.clear();
                      await  masterProvider.fetchLocation();
                      if (provider.cart!.isNotEmpty) {
                        var paramterId = provider.cart!
                            .sublist(0, provider.cart!.length)
                            .join(",");
                       await provider.fetchParamLabs(
                            masterProvider.selectedStateId!, paramterId);
                        provider.isParam = true;
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
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              backgroundColor: Colors.transparent,
              body: provider.isLoading
                  ? LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
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
                                              fontFamily: 'OpenSans',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Price',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: provider.parameterList.map((param) {
                                        bool isSelected = provider.cart!.any(
                                          (item) =>
                                              item.parameterId ==
                                              param.parameterId,
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
                                                          provider.toggleCart(
                                                              param);
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(width: 10),
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        param.parameterName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontSize: 14),
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
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'OpenSans',
                                                  ),
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
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
