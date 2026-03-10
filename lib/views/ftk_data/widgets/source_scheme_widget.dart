import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/ftk_data/fkt_submit_sample.dart';
import 'package:provider/provider.dart';

import 'time_address_widget.dart';

class SourceOfSchemeWidget extends StatelessWidget {
  final Masterprovider masterProvider;
  final String? sourceId;
  final UserSessionManager session;

  const SourceOfSchemeWidget({
    super.key,
    required this.masterProvider,
    required this.sourceId,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: sourceId == "2" &&
              (masterProvider.selectedScheme?.isNotEmpty ?? false),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(10),
              // Inner padding
              margin: const EdgeInsets.only(top: 12),
              // Spacing from the previous widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  Text(
                    'Select Sub-Source Category:',
                    style: AppStyles.textStyleBoldBlack16,
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      const Text(
                        'Ground water sources (GW)',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'OpenSans'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: masterProvider.selectedSubSource,
                        onChanged: (value) {
                          masterProvider.selectRadioOption(value!);
                        },
                      ),
                      const Text(
                        'Surface water sources (SW)',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'OpenSans'),
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
          visible: masterProvider.selectedSubSource != null && sourceId == "2",
          child: Card(
            elevation: 5,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  masterProvider.baseStatus == 0
                      ? AppTextWidgets.errorText(masterProvider.errorMsg)
                      : CustomDropdown(
                          title: "Select Water Source *",
                          appBarTitle: "Select Water Source",
                          value: masterProvider.selectedWaterSource,
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
                              orElse: () => masterProvider.waterSource
                                  .first, // Handle the case where no match is found (optional)
                            );
                            masterProvider
                                .setSelectedWaterSourceInformationName(
                                    selectedWaterSource.locationName);
                            masterProvider
                                .setSelectedWaterSourceInformation(value);
                          },
                        ),
                  const SizedBox(
                    height: 10,
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
                              // Full width of the parent
                              child: ElevatedButton(
                                onPressed: () {
                                  if (masterProvider.validateSourceofScheme()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider.value(
                                          value: masterProvider,
                                          child: const FtkParameterListScreen(),
                                        ),
                                      ),
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
      ],
    );
  }
}
