import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/providers/testing_date_time_provider.dart';
import 'package:jjm_wqmis/views/ftk_data/screens/testing_date_time_picker.dart';
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

              // Storage / Handpump = disabled
              enabled: !testingProvider.isFixedDateTimeSource,

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

              firstDate: testingProvider.windowStart,
              lastDate: testingProvider.windowEnd,

              selectedDateTime: testingProvider.testedDateTime,

              // Normal source:
              // Collection + 5 minutes
              //
              // Storage / Handpump:
              // null = no gap
              minimumDateTime: testingProvider.minimumTestedDateTime,

              // Normal source:
              // collection must be selected first
              //
              // Storage / Handpump:
              // automatically enabled visually but
              // picker itself remains disabled because
              // isFixedDateTimeSource = true
              enabled: !testingProvider.isFixedDateTimeSource &&
                  testingProvider.collectionDateTime != null,

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
