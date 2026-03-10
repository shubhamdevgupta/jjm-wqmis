import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_textfield.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/ftk_data/fkt_submit_sample.dart';

import 'time_address_widget.dart';

class HandpumpWaterWidget extends StatelessWidget {
  final Masterprovider masterProvider;
  final String? sourceId;

  const HandpumpWaterWidget({
    super.key,
    required this.masterProvider,
    required this.sourceId,
  });

  @override
  Widget build(BuildContext context) {

    if (sourceId != "4" ||
        (masterProvider.selectedScheme?.isEmpty ?? true)) {
      return const SizedBox();
    }

    return Column(
      children: [
        Visibility(
          visible: sourceId == "4" &&
              (masterProvider.selectedScheme?.isNotEmpty ?? false),
          child: Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(10),
              // Inner padding
              margin: const EdgeInsets.only(top: 12),
              // Spacing from the first container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 7,
                        groupValue: masterProvider.selectedHandpumpPrivate,
                        onChanged: (value) {
                          masterProvider.setSelectedHabitation("0");
                          masterProvider.cleartxt();
                          masterProvider.selectRadioOption(value!);

                        },
                      ),
                      InkWell(
                          onTap: () {
                            masterProvider.cleartxt();
                            masterProvider.selectRadioOption(7);
                          },
                          child: const Text('Govt. Handpump')),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 8,
                        groupValue: masterProvider.selectedHandpumpPrivate,
                        onChanged: (value) {
                          masterProvider.cleartxt(); // if you want to clear text fields too
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          masterProvider.cleartxt(); // if needed
                          masterProvider.selectRadioOption(8);
                        },
                        child: const Text('Private source location'),
                      ),
                    ],
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
          visible: masterProvider.selectedHandpumpPrivate == 8,
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
                    "Select Habitation *",
                    style: TextStyle(
                      fontSize: 16, fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color:
                      Colors.black87, // Dark text for better readability
                    ),
                  ),

                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 4),
                  // Space between title and dropdown
                  CustomDropdown(
                    title: "",
                    value: masterProvider.selectedHabitation,
                    showSearchBar: true,
                    items: masterProvider.habitationId.map((habitation) {
                      return DropdownMenuItem<String>(
                        value: habitation.habitationId.toString(),
                        child: Text(
                          habitation.habitationName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      masterProvider.setSelectedHabitation(value);
                    },
                    appBarTitle: "Select Habitation",
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
          visible:
          masterProvider.selectedHandpumpPrivate == 7 && sourceId == "4",
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  masterProvider.baseStatus == 0
                      ? AppTextWidgets.errorText(masterProvider.errorMsg)
                      : CustomDropdown(
                    title: "Select Govt. Handpump *",
                    appBarTitle: "Govt Handpump",
                    value: masterProvider.waterSource.any((item) =>
                    item.locationId ==
                        masterProvider.selectedWaterSource)
                        ? masterProvider.selectedWaterSource
                        : null,
                    items: masterProvider.waterSource.map((waterSource) {
                      return DropdownMenuItem<String>(
                        value: waterSource.locationId,
                        child: Text(
                          waterSource.locationName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selectedWaterSource =
                      masterProvider.waterSource.firstWhere(
                            (source) => source.locationId == value,
                        orElse: () => masterProvider.waterSource.first,
                      );
                      masterProvider.setSelectedWaterSourceInformationName(selectedWaterSource.locationName);
                      masterProvider.setSelectedWaterSourceInformation(value);
                    },
                  ),
                  Visibility(
                      visible: masterProvider.selectedWaterSource != "",
                      child: Column(
                        children: [
                          TimeAddressWidget(masterProvider: masterProvider),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (masterProvider.validateHandpumpWaterFields()) {
                                    masterProvider.sampleTypeOther =
                                        masterProvider.handpumpSourceController.text;
                                    masterProvider.otherSourceLocation =
                                        masterProvider.handpumpLocationController.text;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                                value: masterProvider,
                                                child: const FtkParameterListScreen(),
                                              )),
                                    );
                                  } else {
                                    ToastHelper.showToastMessage(masterProvider.errorMsg);
                                  }
                                },
                                style: AppStyles.buttonStylePrimary(),
                                child: const Text(
                                  'Next',
                                  style: AppStyles.textStyle,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),

                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible:
          masterProvider.selectedHandpumpPrivate == 8 && sourceId == "4" && masterProvider.selectedHabitation != null &&
              masterProvider.selectedHabitation != "0",
          child: Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Slightly increased border radius for a smooth look
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    labelText: 'Type of source *',
                    hintText: 'Enter Source type',
                    prefixIcon: Icons.edit_calendar_sharp,
                    controller: masterProvider.handpumpSourceController,
                    isRequired: true,
                  ),
                  CustomTextField(
                    labelText: 'Enter Location *',
                    hintText: 'Enter Location',
                    prefixIcon: Icons.dehaze,
                    controller: masterProvider.handpumpLocationController,
                    isRequired: true,
                  ),
                  TimeAddressWidget(masterProvider: masterProvider),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (masterProvider.validateHandpumpWaterFields()) {
                            masterProvider.sampleTypeOther =
                                masterProvider.handpumpSourceController.text;
                            masterProvider.otherSourceLocation =
                                masterProvider.handpumpLocationController.text;
                            masterProvider.setSelectedWaterSourceInformation("0");
                            masterProvider.setSelectedWaterSourceInformationName(" ");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                        value: masterProvider,
                                        child: const FtkParameterListScreen(),
                                      )),
                            );
                          } else {
                            ToastHelper.showToastMessage(masterProvider.errorMsg);
                          }
                        },
                        style: AppStyles.buttonStylePrimary(),
                        child: const Text(
                          'Next',
                          style: AppStyles.textStyle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}