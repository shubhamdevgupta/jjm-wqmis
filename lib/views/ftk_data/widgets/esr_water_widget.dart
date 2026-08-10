import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/views/ftk_data/fkt_submit_sample.dart';
import 'package:provider/provider.dart';

import 'time_address_widget.dart';

class EsrWaterWidget extends StatefulWidget {
  final Masterprovider masterProvider;
  final String? sourceId;

  const EsrWaterWidget({
    super.key,
    required this.masterProvider,
    required this.sourceId,
  });

  @override
  State<EsrWaterWidget> createState() => _EsrWaterWidgetState();
}

class _EsrWaterWidgetState extends State<EsrWaterWidget> {
  @override
  Widget build(BuildContext context) {
    // Access constructor values through widget.
    final Masterprovider masterProvider = widget.masterProvider;
    final String? sourceId = widget.sourceId;

    if (sourceId != "6") {
      return const SizedBox();
    }

    return Card(
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
            masterProvider.baseStatus == 0
                ? AppTextWidgets.errorText(
                    masterProvider.errorMsg,
                  )
                : CustomDropdown(
                    title: "Select ESR/GSR *",
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
                      masterProvider.setSelectedWaterSourceInformation(value);
                    },
                  ),
            const SizedBox(height: 10),
            Visibility(
              visible: masterProvider.selectedWaterSource != "",
              child: Column(
                children: [
                  TimeAddressWidget(
                    masterProvider: masterProvider,
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (masterProvider.validateEsrWaterFields()) {
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
                              masterProvider.errorMsg,
                            );
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
          ],
        ),
      ),
    );
  }
}
