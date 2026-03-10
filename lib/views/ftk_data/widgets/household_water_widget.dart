import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_textfield.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/ftk_data/fkt_submit_sample.dart';
import 'package:provider/provider.dart';

import 'time_address_widget.dart';

class HouseholdWaterWidget extends StatelessWidget {
  final Masterprovider masterProvider;
  final String? sourceId;
  final UserSessionManager session;

  const HouseholdWaterWidget({
    super.key,
    required this.masterProvider,
    required this.sourceId,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    if (sourceId != "3") {
      return const SizedBox();
    }
    return Column(
      children: [
        Card(
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
                    color: Colors.black87, // Dark text for better readability
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
                  showSearchBar: false,
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
        if (masterProvider.selectedHabitation != null &&
            masterProvider.selectedHabitation != "0")
          Card(
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
                    "Select Scheme *",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  CustomDropdown(
                    value: masterProvider.selectedScheme,
                    showSearchBar: true,
                    items: masterProvider.schemes.map((scheme) {
                      return DropdownMenuItem<String>(
                        value: scheme.schemeId.toString(),
                        child: Text(
                          scheme.schemeName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    title: "",
                    appBarTitle: "Select Scheme",
                    onChanged: (value) {
                      masterProvider.setSelectedScheme(value);
                    },
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: sourceId=="3" && masterProvider.selectedScheme!=null,
          child: Card(
            elevation: 5, // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Slightly increased border radius for a smooth look
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
                        value: 3,
                        groupValue: masterProvider.selectedHousehold,
                        onChanged: (value) {
                          masterProvider.householdController.clear();
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          masterProvider.householdController.clear();
                          masterProvider.selectRadioOption(3);
                        },
                        child: const Text('At household'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 4,
                        groupValue: masterProvider.selectedHousehold,
                        onChanged: (value) async {
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          masterProvider.householdController.clear();
                          masterProvider.selectRadioOption(4);
                          masterProvider.setSelectedSubSource(2);
                          await masterProvider.fetchSourceInformation(
                              masterProvider.selectedVillage!,
                              "0",
                              masterProvider.selectedWtsfilter!,
                              masterProvider.selectedSubSource.toString(),
                              "0",
                              "0",
                              masterProvider.selectedStateId!,
                              masterProvider.selectedScheme!,
                              session.regId);
                        },
                        child: const Text('At school/AWCs'),
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
          visible: masterProvider.selectedHousehold == 3,
          child: Card(
            elevation: 5,
            // Increased elevation for a more modern shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Slightly increased border radius for a smooth look
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  CustomTextField(
                    labelText: 'Name of household *',
                    hintText: 'Enter Location',
                    prefixIcon: Icons.cabin_rounded,
                    controller: masterProvider.householdController,
                    isRequired: true,
                  ),
                  TimeAddressWidget(masterProvider: masterProvider),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (masterProvider.validateHouseholdWaterFields()) {
                            masterProvider.otherSourceLocation =
                                masterProvider.householdController.text;
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
                            ToastHelper.showToastMessage(
                                masterProvider.errorMsg);
                          }
                        },
                        style: AppStyles.buttonStylePrimary(),
                        child: const Text(
                          'Next',
                          style: AppStyles.textStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: masterProvider.selectedHousehold == 4,
          child: Card(
            elevation: 5,
            // Increased elevation for a more modern shadow effect
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
                  masterProvider.baseStatus == 0
                      ? AppTextWidgets.errorText(masterProvider.errorMsg)
                      : CustomDropdown(
                          appBarTitle: 'Select School / AWCs',
                          title: "Select School / AWCs *",
                          value: masterProvider.waterSource.any((item) =>
                                  item.locationId ==
                                  masterProvider.selectedWaterSource)
                              ? masterProvider.selectedWaterSource
                              : null,
                          // Ensure valid value
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
                            masterProvider
                                .setSelectedWaterSourceInformationName(
                                    selectedWaterSource.locationName);
                            masterProvider
                                .setSelectedWaterSourceInformation(value);
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
                                  if (masterProvider
                                      .validateHouseholdWaterFields()) {
                                    masterProvider.otherSourceLocation =
                                        masterProvider.householdController.text;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                                value: masterProvider,
                                                child:
                                                    const FtkParameterListScreen(),
                                              )),
                                    );
                                  } else {
                                    ToastHelper.showToastMessage(
                                        masterProvider.errorMsg);
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
