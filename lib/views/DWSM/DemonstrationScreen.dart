import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:provider/provider.dart';

import '../../models/DWSM/DwsmDashboard.dart';
import '../../providers/dwsmDashboardProvider.dart';


class Demonstrationscreen extends StatefulWidget {

  @override
  State<Demonstrationscreen> createState() => _DemonstrationscreenState();
}

class _DemonstrationscreenState extends State<Demonstrationscreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DwsmDashboardProvider>(context, listen: false).loadDwsmDashboardData(int.parse("31"), 0, "2025-2026");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demonstrations List")),

      body: Consumer<DwsmDashboardProvider>(builder : (context,provider , child){
        return
          provider.isLoading?LoaderUtils.conditionalLoader(isLoading: provider.isLoading):
          ListView.builder(
          itemCount: provider.villages.length,
          itemBuilder: (context, index) {
            final village = provider.villages[index];

            final base64String = village.photo.split(',').last;
            final imageBytes = base64Decode(base64String);

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: Village Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("State: ${village.stateName}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text("District: ${village.districtName}"),
                          Text("Block: ${village.blockName}"),
                          Text("Panchayat: ${village.panchayatName}"),
                          Text("Village: ${village.villageName}"),
                        ],
                      ),
                    ),
                    // Right side: Image
                     ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageBytes,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ],
                ),
              ),
            );
          },
        );
      }
      )

    );
  }
}
