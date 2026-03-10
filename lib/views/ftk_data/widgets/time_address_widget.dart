import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_date_time_picker.dart';

class TimeAddressWidget extends StatelessWidget {

  final Masterprovider masterProvider;

  const TimeAddressWidget({
    super.key,
    required this.masterProvider,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CustomDateTimePicker(
          textTitle: "Date & Time of Sample Collection *",
          onDateTimeSelected: (value) {
            masterProvider.setSelectedDateTime(value);
          },
        ),

        const SizedBox(height: 10),

        CustomDateTimePicker(
          textTitle: "Date & Time of Sample tested *",
          onDateTimeSelected: (value) {
            masterProvider.setSelectedDateTime(value);
          },
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: masterProvider.addressController,
          decoration: const InputDecoration(
            hintText: "Enter Address",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: masterProvider.ftkRemarkController,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: "Enter remarks",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}