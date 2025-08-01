import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/param_lab_response.dart';
import 'package:jjm_wqmis/providers/parameter_provider.dart';
import 'package:jjm_wqmis/providers/sample_submit_provider.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/current_location.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:provider/provider.dart';

class SubmitSampleScreen extends StatefulWidget {
  const SubmitSampleScreen({super.key});

  @override
  State<SubmitSampleScreen> createState() => _SelectedSampleScreenState();
}

class _SelectedSampleScreenState extends State<SubmitSampleScreen> {
  final TextEditingController remarkController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final session = UserSessionManager();
  final lat = CurrentLocation.latitude;
  final lng = CurrentLocation.longitude;

  late bool serviceEnabled;

  TextStyle _headerTextStyle() => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
      );

  TextStyle _rowTextStyle() => const TextStyle(
        fontSize: 14,
        fontFamily: 'OpenSans',
      );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.init();

      final masterProvider = Provider.of<Masterprovider>(context, listen: false);
      if (CurrentLocation.latitude != null &&
          CurrentLocation.longitude != null) {
        masterProvider.setLocation(
          CurrentLocation.latitude,
          CurrentLocation.longitude,
        );
      }
      if (masterProvider.lat == null || masterProvider.lng == null) {
        masterProvider.checkAndPromptLocation(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paramProvider = Provider.of<ParameterProvider>(context, listen: true);
    final masterProvider = Provider.of<Masterprovider>(context, listen: false);
    const double rowHeight = 50.0;
    const double maxTableHeight = 250.0;
    return Consumer<Samplesubprovider>(builder: (context, provider, child) {

      return Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/header_bg.png'),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 5,
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8),
                  right: Radius.circular(8),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(
                        context, AppConstants.navigateToLabParam);
                  }
                },
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF096DA8), // Dark blue color
                      Color(0xFF3C8DBC), // jjm blue color
                    ],
                    begin: Alignment.topCenter, // Start at the top center
                    end: Alignment.bottomCenter, // End at the bottom center
                  ),
                ),
              ),
              title: Text(
                AppConstants.selectedTest,
                style: AppStyles.appBarTitle,
              ),
            ),
            body: provider.isLoading
                ? LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                : Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.8, // Adjust 0.8 as needed
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              controller: _scrollController,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    //lab box
                                Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        // Fixed Header
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              _buildHeaderCell("Sr. No.", width: 70),
                                              _buildHeaderCell("Test Name", width: MediaQuery.of(context).size.width * 0.4),
                                              _buildHeaderCell("Price", width: 70),
                                              _buildHeaderCell("Action", width: 70),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        // Scrollable Rows
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            int itemCount = paramProvider.cart?.length ?? 0;
                                            double calculatedHeight = itemCount * rowHeight;
                                            double tableHeight = calculatedHeight > maxTableHeight
                                                ? maxTableHeight
                                                : calculatedHeight;

                                            return ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight: tableHeight,
                                              ),
                                              child: Scrollbar(
                                                thumbVisibility: true,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Column(
                                                      children: paramProvider.cart!.asMap().entries.map((entry) {
                                                        int index = entry.key;
                                                        var param = entry.value;
                                                        return Row(
                                                          children: [
                                                            _buildRowCell('${index + 1}', width: 70),
                                                            _buildRowCell(param.parameterName, width: MediaQuery.of(context).size.width * 0.4),
                                                            _buildRowCell(param.deptRate.toString(), width: 70),
                                                            SizedBox(
                                                              width: 70,
                                                              child: IconButton(
                                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                                onPressed: ()async {
                                                                  if (paramProvider.cart!.length > 1) {
                                                                    paramProvider.removeFromCart(param);
                                                                    if (paramProvider.isParam) {
                                                                      var paramterId = paramProvider.cart!
                                                                          .sublist(0, paramProvider.cart!.length)
                                                                          .join(",");
                                                                    await  paramProvider.fetchParamLabs(
                                                                          masterProvider.selectedStateId!,
                                                                          paramterId,session.regId);
                                                                      paramProvider.selectedLab = "";
                                                                    }
                                                                  } else {
                                                                    ToastHelper.showSnackBar(context, "Parameter cannot be empty");
                                                                  }
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
                                            );
                                          },
                                        ),

                                        const Divider(),

                                        // Total Price Section
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Text("Total Price",
                                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 20),
                                              Text("₹ ${paramProvider.calculateTotal()} /-",
                                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Visibility(
                                      visible: paramProvider.isLab,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: TextFormField(
                                                controller: remarkController,
                                                maxLines: 2,
                                                // Allows multiline input
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 14,
                                                          horizontal: 16),
                                                  // Better padding
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    // Smoother rounded edges
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 1),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Colors.blueAccent,
                                                        width:
                                                            1.5), // Focus highlight
                                                  ),
                                                  hintText:
                                                      "Enter your remarks",
                                                  hintStyle: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          Colors.grey.shade600),
                                                  suffixIcon: remarkController
                                                          .text.isNotEmpty
                                                      ? IconButton(
                                                          icon: const Icon(
                                                              Icons.clear,
                                                              color:
                                                                  Colors.grey),
                                                          onPressed: () {
                                                            remarkController
                                                                .clear(); // Clears text on click
                                                          },
                                                        )
                                                      : null,
                                                ),
                                                keyboardType:
                                                    TextInputType.multiline,
                                                textInputAction: TextInputAction
                                                    .newline, // Allows new line input
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          paramProvider.baseStatus == 0
                                              ? AppTextWidgets.errorText(
                                                  paramProvider.errorMsg)
                                              : Card(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      // Rounded corners
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          // Shadow color
                                                          blurRadius: 10,
                                                          // Shadow blur
                                                          offset: const Offset(
                                                              0,
                                                              5), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Section 1: Lab Incharge Details
                                                        const Text(
                                                          "Lab Incharge Details",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                        ),
                                                        Divider(
                                                            thickness: 1,
                                                            color: Colors
                                                                .grey.shade300),
                                                        // Divider for separation
                                                        const SizedBox(
                                                            height: 8),

                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .blueAccent),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                              child: Text(
                                                                'Name: ${paramProvider.labIncharge?.name ?? "N/A"}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),

                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.business,
                                                                color: Colors
                                                                    .green),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                              child: Text(
                                                                'Lab Name: ${paramProvider.labIncharge?.labName ?? "N/A"}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),

                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Colors
                                                                    .redAccent),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                              child: Text(
                                                                'Address: ${paramProvider.labIncharge?.address ?? "N/A"}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  // Rounded corners
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      // Shadow color
                                                      blurRadius: 10,
                                                      // Shadow blur
                                                      offset: const Offset(0,
                                                          5), // Shadow position
                                                    ),
                                                  ],
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Geo Location of Sample Taken:",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blueGrey,
                                                      ),
                                                    ),
                                                    Divider(
                                                        thickness: 1,
                                                        color: Colors
                                                            .grey.shade300),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Latitude:',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        Text(
                                                          "${masterProvider.lat?.toStringAsFixed(6)}",
                                                          // Display placeholder text if null
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Longitude :',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        Text(
                                                          "${masterProvider.lng?.toStringAsFixed(6)}",
                                                          // Display placeholder text if null
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: paramProvider.isParam,
                                      child: Column(
                                        children: [
                                          !paramProvider.isLab &&
                                                  paramProvider.baseStatus == 0
                                              ? Text(
                                                  paramProvider.errorMsg,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: CustomDropdown(
                                                        title: "Select Lab *",
                                                        value: paramProvider
                                                            .selectedParamLabId
                                                            ?.toString(),
                                                        // Selected value
                                                        items: paramProvider
                                                                .labResponse
                                                                ?.map((lab) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: lab.labId
                                                                    .toString(),
                                                                // Use lab ID as value
                                                                child: Text(
                                                                  lab.labName,
                                                                  // Show lab name in dropdown
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              );
                                                            }).toList() ??
                                                            [],
                                                        // Handle null case
                                                        onChanged: (value) {
                                                          if (value != null) {
                                                            final selectedLab =
                                                                paramProvider
                                                                    .labResponse!
                                                                    .firstWhere(
                                                              (lab) =>
                                                                  lab.labId
                                                                      .toString() ==
                                                                  value,
                                                              orElse: () => Lab(
                                                                  labId: 0,
                                                                  labName: ''),
                                                            );
                                                            paramProvider
                                                                .setSelectedParamLabs(
                                                                    selectedLab
                                                                        .labId,
                                                                    selectedLab
                                                                        .labName);
                                                            paramProvider
                                                                .fetchLabIncharge(
                                                                    selectedLab
                                                                        .labId,session.regId);
                                                            paramProvider
                                                                .setSelectedLab(
                                                                    value);
                                                          }
                                                        },
                                                        appBarTitle:
                                                            "Select Lab ",
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: paramProvider
                                                              .selectedParamLabId !=
                                                          0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller:
                                                                remarkController,
                                                            maxLines: 2,
                                                            // Allows multiline input
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          14,
                                                                      horizontal:
                                                                          16),
                                                              // Better padding
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                // Smoother rounded edges
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    width: 1),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    width:
                                                                        1.5), // Focus highlight
                                                              ),
                                                              hintText:
                                                                  "Enter your remarks",
                                                              hintStyle: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600),
                                                              suffixIcon:
                                                                  remarkController
                                                                          .text
                                                                          .isNotEmpty
                                                                      ? IconButton(
                                                                          icon: const Icon(
                                                                              Icons.clear,
                                                                              color: Colors.grey),
                                                                          onPressed:
                                                                              () {
                                                                            remarkController.clear(); // Clears text on click
                                                                          },
                                                                        )
                                                                      : null,
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .newline, // Allows new line input
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: paramProvider
                                                              .selectedParamLabId !=
                                                          0,
                                                      child: Card(
                                                        elevation: 4,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10,
                                                            vertical: 8),
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Section 1: Lab Incharge Details
                                                              const Text(
                                                                "Lab Incharge Details",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                              ),
                                                              Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                              // Divider for separation
                                                              const SizedBox(
                                                                  height: 8),

                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: Colors
                                                                          .blueAccent),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Expanded(
                                                                    child: Text(
                                                                      'Name: ${paramProvider.labIncharge?.name ?? "N/A"}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),

                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .business,
                                                                      color: Colors
                                                                          .green),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Expanded(
                                                                    child: Text(
                                                                      'Lab Name: ${paramProvider.labIncharge?.labName ?? "N/A"}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),

                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      color: Colors
                                                                          .redAccent),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Expanded(
                                                                    child: Text(
                                                                      'Address: ${paramProvider.labIncharge?.address ?? "N/A"}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: paramProvider
                                                              .selectedParamLabId !=
                                                          0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              // Rounded corners
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  // Shadow color
                                                                  blurRadius:
                                                                      10,
                                                                  // Shadow blur
                                                                  offset: const Offset(
                                                                      0,
                                                                      5), // Shadow position
                                                                ),
                                                              ],
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  "Geo Location of Sample Taken:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .blueGrey,
                                                                  ),
                                                                ),
                                                                Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      'Latitude:',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black87,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 16,
                                                                    ),
                                                                    Text(
                                                                      "${masterProvider.lat?.toStringAsFixed(6)}",
                                                                      // Display placeholder text if null
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.7),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      'Longitude :',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black87,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 16,
                                                                    ),
                                                                    Text(
                                                                      "${masterProvider.lng?.toStringAsFixed(6)}",
                                                                      // Display placeholder text if null
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.7),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
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
                      Visibility(
                        visible: paramProvider.isLab &&
                            paramProvider.baseStatus != 0,
                        // Show only when status is true
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14, left: 14),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  validateAndSubmit(context, provider,
                                      masterProvider, paramProvider);
                                },
                                style: AppStyles.buttonStylePrimary(),
                                child: const Text(
                                  AppConstants.submitSample,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: paramProvider.isParam &&
                            paramProvider.baseStatus == 1 &&
                            paramProvider.selectedParamLabId != 0,
                        // Show only when status is true
                        child: ElevatedButton(
                            onPressed: () {
                              validateAndSubmit(context, provider,
                                  masterProvider, paramProvider);
                            },
                            style: AppStyles.buttonStylePrimary(),
                            child: const Text(
                              AppConstants.submitSample,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  Future<void> validateAndSubmit(
      BuildContext context,
      Samplesubprovider provider,
      Masterprovider masterProvider,
      ParameterProvider paramProvider) async {
    if (paramProvider.cart == null || paramProvider.cart!.isEmpty) {
      ToastHelper.showSnackBar(context, "Please select at least one test.");
      return;
    }
    await masterProvider.fetchLocation();

    if (masterProvider.lat == null || masterProvider.lng == null) {
      await masterProvider.checkAndPromptLocation(context);

      if (masterProvider.lat == null || masterProvider.lng == null) {
        // User cancelled or GPS still off
        ToastHelper.showSnackBar(context, "Location is required to proceed.");
        return;
      }
    }
    await provider.fetchDeviceId();
    //TODO lab is null here
    int parsedSource =
        int.tryParse(masterProvider.selectedWaterSource?.toString() ?? '') ?? 0;

    int selecteTypeId;
    if (paramProvider.isLab) {
      selecteTypeId = int.parse(paramProvider.selectedLab!);
    } else {
      selecteTypeId = paramProvider.selectedParamLabId!;
    }

    await provider.sampleSubmit(
      selecteTypeId,
      session.regId,
      session.roleId,
      masterProvider.selectedDatetime,
      int.parse(masterProvider.selectedSubSource.toString()),
      parsedSource,
      int.parse(masterProvider.selectedStateId.toString()),
      int.parse(masterProvider.selectedDistrictId.toString()),
      int.parse(masterProvider.selectedBlockId.toString()),
      int.parse(masterProvider.selectedGramPanchayat.toString()),
      int.parse(masterProvider.selectedVillage.toString()),
      int.parse(masterProvider.selectedHabitation.toString()),
      int.parse(masterProvider.selectedWtsfilter.toString()),
      int.parse(masterProvider.selectedScheme.toString()),
      masterProvider.otherSourceLocation,
      masterProvider.selectedWaterSource,
      masterProvider.lat!.toStringAsFixed(6),
      masterProvider.lng!.toStringAsFixed(6),
      remarkController.text,
      provider.deviceId,
      masterProvider.sampleTypeOther,
      int.parse(masterProvider.selectedWtp ?? '0'),
      masterProvider.istreated,
      paramProvider.cart!.sublist(0, paramProvider.cart!.length).join(","),
      "M",
    );
    if (provider.sampleresponse!.status == 1) {
      showDialog(
        context: context,
        barrierDismissible: false, // Disable tap outside to dismiss
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.only(top: 20),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          title: Column(
            children: [
              Image.asset(
                'assets/icons/check.png',
                // <-- Your success image (PNG) path here
                height: 60,
                width: 80,
              ),
              const SizedBox(height: 10),
              const Text(
                "Success!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Text(
            provider.sampleresponse?.message ??
                'Operation completed successfully!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppConstants.navigateToDashboardScreen,
                    (route) => false, // Clear back stack
                  );
                  //    masterProvider.clearData();
                  paramProvider.clearData();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      ToastHelper.showErrorSnackBar(context, provider.errorMsg);
    }
  }

  Widget _buildHeaderCell(String text, {required double width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0,left: 2.0,right: 4.0),
      color: Colors.blue,
      child: Text(
        text,
        style: _headerTextStyle(),
      ),
    );
  }

  Widget _buildRowCell(String text, {required double width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: _rowTextStyle(),
      ),
    );
  }

}
