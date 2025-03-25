import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:provider/provider.dart';

import '../providers/SampleSubmitProvider.dart';
import '../providers/masterProvider.dart';
import '../services/LocalStorageService.dart';

class SelectedTestScreen extends StatefulWidget {
  const SelectedTestScreen({super.key});

  @override
  State<SelectedTestScreen> createState() => _SelectedTestScreenState();
}

class _SelectedTestScreenState extends State<SelectedTestScreen> {
  final TextEditingController remarkController = TextEditingController();
  final LocalStorageService _localStorage = LocalStorageService();
  final ScrollController _scrollController = ScrollController();

  TextStyle _headerTextStyle() =>
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  TextStyle _rowTextStyle() => TextStyle(fontSize: 14);
  @override
  void dispose() {
    _scrollController.dispose(); // Clean up controller when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paramProvider =Provider.of<ParameterProvider>(context, listen: false);
    final masterProvider = Provider.of<Masterprovider>(context, listen: false);

    return ChangeNotifierProvider(
        create: (_) => Samplesubprovider(),
        child: Consumer<Samplesubprovider>(builder: (context, provider, child) {
          return Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
              ),
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, '/labParam');
                      }
                    },
                  ),
                  backgroundColor: Colors.blueAccent, // Consistent theme
                  title: const Text(
                    'Selected Test',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Card(
                              elevation: 4,
                              color: Colors.white, // White background
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      // Dynamic height adjustment
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              250, // Maximum height before scrolling starts
                                        ),
                                        child: paramProvider.cart!.isEmpty
                                            ? Center(
                                                child: Text(
                                                    "No tests selected")) // Show message if no items
                                            : Container(
                                                constraints: BoxConstraints(
                                                  minHeight: 0,
                                                  // Allow shrinking when few items
                                                  maxHeight:
                                                      250, // Max height to enable scrolling
                                                ),
                                                child: Scrollbar(
                                                  thumbVisibility: true,
                                                  // Show scrollbar when scrolling
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    // Enables vertical scrolling inside the card
                                                    child: SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      // Enables horizontal scrolling if needed
                                                      child: DataTable(
                                                        headingRowColor:
                                                            MaterialStateProperty
                                                                .all(Colors.blue),
                                                        columnSpacing:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.02,
                                                        columns: [
                                                          DataColumn(
                                                              label: Text(
                                                                  'Sr. No.',
                                                                  style:
                                                                      _headerTextStyle())),
                                                          DataColumn(
                                                              label: Text(
                                                                  'Test Name',
                                                                  style:
                                                                      _headerTextStyle())),
                                                          DataColumn(
                                                              label: Text('Price',
                                                                  style:
                                                                      _headerTextStyle())),
                                                          DataColumn(
                                                              label: Text(
                                                                  'Action',
                                                                  style:
                                                                      _headerTextStyle())),
                                                        ],
                                                        rows: paramProvider.cart!
                                                            .asMap()
                                                            .entries
                                                            .map((entry) {
                                                          int index = entry.key;
                                                          var param = entry.value;

                                                          return DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(Text(
                                                                  '${index + 1}',
                                                                  style:
                                                                      _rowTextStyle())),
                                                              DataCell(SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                child: Text(
                                                                    param
                                                                        .parameterName,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        _rowTextStyle()),
                                                              )),
                                                              DataCell(Text(
                                                                  param.deptRate
                                                                      .toString(),
                                                                  style:
                                                                      _rowTextStyle())),
                                                              DataCell(
                                                                IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red),
                                                                  onPressed: () {
                                                                    paramProvider
                                                                        .removeFromCart(
                                                                            param);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),

                                      Divider(),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text("Total Price",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold)),
                                            SizedBox(width: 20),
                                            Text(
                                                "₹ ${paramProvider.calculateTotal()} /-",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: remarkController,
                                  maxLines: 2,
                                  // Allows multiline input
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                    // Better padding
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      // Smoother rounded edges
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent,
                                          width: 1.5), // Focus highlight
                                    ),
                                    hintText: "Enter your remarks",
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                    suffixIcon: remarkController.text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.clear,
                                                color: Colors.grey),
                                            onPressed: () {
                                              remarkController
                                                  .clear(); // Clears text on click
                                            },
                                          )
                                        : null,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction
                                      .newline, // Allows new line input
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Section 1: Lab Incharge Details
                                    Text(
                                      "Lab Incharge Details",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    Divider(
                                        thickness: 1,
                                        color: Colors.grey.shade300),
                                    // Divider for separation
                                    SizedBox(height: 8),

                                    Row(
                                      children: [
                                        Icon(Icons.person,
                                            color: Colors.blueAccent),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Name: ${paramProvider.labIncharge?.name ?? "N/A"}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Icon(Icons.business, color: Colors.green),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Lab Name: ${paramProvider.labIncharge?.labName ?? "N/A"}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            color: Colors.redAccent),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Address: ${paramProvider.labIncharge?.address ?? "N/A"}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    // Rounded corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        // Shadow color
                                        blurRadius: 10,
                                        // Shadow blur
                                        offset:
                                            const Offset(0, 5), // Shadow position
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Geo Location of Sample Taken:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      Divider(
                                          thickness: 1,
                                          color: Colors.grey.shade300),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Latitude:',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            "${paramProvider.currentPosition!.latitude}",
                                            // Display placeholder text if null
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Longitude :',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            "${paramProvider.currentPosition!.longitude}",
                                            // Display placeholder text if null
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  validateAndSubmit(context, provider,
                                      masterProvider, paramProvider);

                                  if (provider.isSubmitData!=false) {
                                    print('submitdata succesfully------ ${provider.isSubmitData}');
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Success"),
                                          content: Text(
                                              provider.sampleresponse!.message),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Close dialog
                                                Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    '/dashboard',
                                                    (route) =>
                                                        false); // Go to Dashboard
                                              },
                                              child: Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    print('submitdata failed------ ${provider.isSubmitData}');
                                    ToastHelper.showErrorSnackBar(context, provider.errorMsg);
                                  }
                                },
                                child: Text(
                                  'Submit Sample',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF096DA8),
                                  // Button color
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 100.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                )),
                            SizedBox(height: 10),
                            Text(
                              "* Labs are not available with this combination (package)${paramProvider.cart!.length}",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (provider.isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        // Background opacity
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  void validateAndSubmit(BuildContext context, Samplesubprovider provider,
      Masterprovider masterProvider, ParameterProvider paramProvider) async{
    String userId = _localStorage.getString('userId')!;
    String roleId = _localStorage.getString('roleId')!;
    
    if (paramProvider.cart == null || paramProvider.cart!.isEmpty) {
      showSnackbar(context, "Please select at least one test.");
      return;
    }
print("---------${masterProvider.selectedWaterSource.toString()}");
  await provider.fetchDeviceId();
    provider.sampleSubmit(
      int.parse(paramProvider.selectedLab.toString()),
      int.parse(userId),
      int.parse(roleId),
      masterProvider.selectedDatetime,
      int.parse(masterProvider.selectedSubSource.toString()),
      int.parse(masterProvider.selectedWaterSource.toString()),
      int.parse(masterProvider.selectedStateId.toString()),
      int.parse(masterProvider.selectedDistrictId.toString()),
      int.parse(masterProvider.selectedBlockId.toString()),
      int.parse(masterProvider.selectedGramPanchayat.toString()),
      int.parse(masterProvider.selectedVillage.toString()),
      int.parse(masterProvider.selectedHabitation.toString()),
      int.parse(masterProvider.selectedWtsfilter.toString()),
      int.parse(masterProvider.selectedScheme.toString()),
      masterProvider.otherSourceLocation,
      "",
      paramProvider.currentPosition!.latitude.toString(),
      paramProvider.currentPosition!.longitude.toString(),
      remarkController.text,
      provider.deviceId,
      masterProvider.sampleTypeOther,
      0,
      paramProvider.cart!.sublist(0, paramProvider.cart!.length).join(","),
      "M",
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
