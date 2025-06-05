import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/Showerrormsg.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/SubmitSampleScreen.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';
import 'package:jjm_wqmis/utils/CustomDropdown.dart';

class Wtplabscreen extends StatefulWidget {
  const Wtplabscreen({super.key});

  @override
  _WtpLabScreen createState() => _WtpLabScreen();
}

class _WtpLabScreen extends State<Wtplabscreen> {
  late Masterprovider masterProvider;
  final LocalStorageService _localStorage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paramProvider =
          Provider.of<ParameterProvider>(context, listen: false);
      paramProvider.fetchWTPLab(masterProvider);
      paramProvider.clearData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParameterProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/header_bg.png'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            floatingActionButton: Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    provider.isLab = true;
                    provider.isParam = false;
                    if (provider.cart!.isNotEmpty) {
                      provider.fetchLabIncharge(
                          int.parse(provider.selectedWtpLab!));
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
                          content: Text("Please Select  test."),
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
            appBar: AppBar(
                title: Text(
                  'Water Treatment Plant',
                  style: AppStyles.appBarTitle,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, AppConstants.navigateToSubmitSampleScreen);
                    }
                  },
                ),
                backgroundColor: Colors.blueAccent,
                // Consistent theme
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
                                  child: const SubmitSampleScreen(),
                                ),
                              ),
                            );
                          } else {
                            ToastHelper.showErrorSnackBar(
                                context, "Please Select Test");
                          }
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
                                  fontFamily: 'OpenSans',
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
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF096DA8), // Dark blue
                        Color(0xFF3C8DBC), // jjm blue color
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter, // End at the bottom center
                    ),
                  ),
                )),
            body: provider.isLoading
                ? LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                : provider.baseStatus==0?Center(child: AppTextWidgets.errorText(provider.errorMsg)): SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomDropdown(
                            title: "Select WTP Lab *",
                            value: provider.selectedWtpLab,
                            items: provider.wtpLab.map((wtpLab) {
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
                              provider.proccessOnChanged(
                                  value!, masterProvider);
                            },
                            appBarTitle: "Wtp Lab",
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
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
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
                                          provider.selectedWtpLab!,
                                          masterProvider.selectedStateId!,
                                          "0",
                                          _localStorage
                                              .getString(AppConstants.prefRegId)
                                              .toString(),
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
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tests Available:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
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
                                          rows: provider.parameterList
                                              .map((param) {
                                            bool isSelected =
                                                provider.cart!.any(
                                              (item) =>
                                                  item.parameterId ==
                                                  param.parameterId,
                                            );

                                            return DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                  GestureDetector(
                                                    onTap: () {
                                                      provider
                                                          .toggleCart(param);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                          value: isSelected,
                                                          onChanged:
                                                              (bool? value) {
                                                            if (value != null) {
                                                              provider
                                                                  .toggleCart(
                                                                      param);
                                                            }
                                                          },
                                                        ),
                                                        const SizedBox(width: 10),
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            param.parameterName,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
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
                                                      provider
                                                          .toggleCart(param);
                                                    },
                                                    child: Text(
                                                      param.deptRate.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
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
          ),
        );
      },
    );
  }
}
