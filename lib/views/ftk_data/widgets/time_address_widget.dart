import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/providers/testing_date_time_provider.dart';
import 'package:jjm_wqmis/views/ftk_data/widgets/testing_date_time_picker.dart';
import 'package:provider/provider.dart';

class TimeAddressWidget extends StatelessWidget {
  final Masterprovider masterProvider;

  const TimeAddressWidget({
    super.key,
    required this.masterProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TestingDateTimeProvider>(
      builder: (
        context,
        testingProvider,
        child,
      ) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====================================================
            // SAMPLE COLLECTION
            // ====================================================

            TestingDateTimePicker(
              title: "Date & Time of Sample Collection *",

              // SAME WINDOW
              firstDate: testingProvider.windowStart,
              lastDate: testingProvider.windowEnd,

              selectedDateTime: testingProvider.collectionDateTime,

              onChanged: (value) {
                testingProvider.setCollectionDateTime(
                  value,
                );
              },
            ),

            const SizedBox(height: 10),

            // ====================================================
            // SAMPLE TESTED
            // ====================================================

            TestingDateTimePicker(
              title: "Date & Time of Sample Tested *",

              // IMPORTANT:
              // Same testing window as collection.
              firstDate: testingProvider.windowStart,
              lastDate: testingProvider.windowEnd,

              selectedDateTime: testingProvider.testedDateTime,

              // Only the TIME has an additional restriction.
              minimumDateTime: testingProvider.minimumTestedDateTime,

              // User must select collection first.
              enabled: testingProvider.collectionDateTime != null,

              onChanged: (value) {
                testingProvider.setTestedDateTime(
                  value,
                );
              },
            ),

            const SizedBox(height: 10),

            // ====================================================
            // ADDRESS
            // ====================================================

            TextFormField(
              controller: masterProvider.addressController,
              decoration: const InputDecoration(
                hintText: "Enter Address",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // ====================================================
            // REMARKS
            // ====================================================

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
      },
    );
  }
}
