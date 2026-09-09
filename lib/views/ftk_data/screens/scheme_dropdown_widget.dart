import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';

class SchemeDropdownWidget extends StatelessWidget {
  final Masterprovider masterProvider;
  final String? sourceId;
  final int regId;

  const SchemeDropdownWidget({
    super.key,
    required this.masterProvider,
    required this.sourceId,
    required this.regId,
  });

  @override
  Widget build(BuildContext context) {

    if (masterProvider.baseStatus == 0 &&
        masterProvider.selectedScheme == null) {
      return Text(masterProvider.errorMsg);
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(left: 5,right: 5),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Scheme",
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
            const SizedBox(height: 4), // Space between title and dropdown
            CustomDropdown(
              value: masterProvider.selectedScheme,
              items: masterProvider.schemes.map((scheme) {
                return DropdownMenuItem<String>(
                  value: scheme.schemeId.toString(),
                  child: Text(
                    scheme.schemeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                );
              }).toList(),
              title: "",
              appBarTitle: "Select Scheme",
              showSearchBar: true,
              onChanged: (value) {

                masterProvider.clearSelection();

                masterProvider.setSelectedScheme(value);
                if (sourceId == "5") {
                  masterProvider.fetchWTPList(
                      masterProvider.selectedStateId!,
                      masterProvider.selectedVillage!,
                      masterProvider.selectedHabitation!,
                      value!,regId
                  );
                } else if (sourceId == "6") {
                  masterProvider.setSelectedSubSource(0);
                  masterProvider.setSelectedWTP("0");
                  masterProvider.fetchSourceInformation(
                      masterProvider.selectedVillage!,
                      masterProvider.selectedHabitation!,
                      sourceId.toString(),
                      "0",
                      masterProvider.selectedSubSource.toString(),
                      masterProvider.selectedWtp!,
                      masterProvider.selectedStateId!,
                      masterProvider.selectedScheme!,regId
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}