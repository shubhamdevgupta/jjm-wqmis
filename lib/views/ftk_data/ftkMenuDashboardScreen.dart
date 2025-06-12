// views/DashboardScreen.dart
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/dashboardProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';
import 'package:jjm_wqmis/utils/custom_screen/CustomDropdown.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:provider/provider.dart';

class Ftkmenudashboardscreen extends StatefulWidget {
  const Ftkmenudashboardscreen({super.key});

  @override
  State<Ftkmenudashboardscreen> createState() => _ftkMenuDashboardScreen();
}

class _ftkMenuDashboardScreen extends State<Ftkmenudashboardscreen> {
  final session = UserSessionManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      session.init();

      final masterProvider = Provider.of<Masterprovider>(context, listen: false);
      masterProvider.fetchWatersourcefilterList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to Dashboard when pressing back button
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppConstants.navigateToFtkDashboard,
          (route) => false, // Clears all previous routes
        );
        return false; // Prevents default back action
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/icons/header_bg.png'),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // Removes the default back button
              centerTitle: true,
              title: Text(
                AppConstants.appTitle,
                style: AppStyles.appBarTitle,
              ),


              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(
                        context, AppConstants.navigateToFtkDashboard);
                  }
                },
              ),
              //elevation
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF096DA8), // Dark blue color
                      Color(0xFF3C8DBC), // Green color
                    ],
                    begin: Alignment.topCenter, // Start at the top center
                    end: Alignment.bottomCenter, // End at the bottom center
                  ),
                ),
              ),
              elevation: 5,
            ),
            body: Consumer<Masterprovider>(
              builder: (context, masterProvider, child) {
                if (masterProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Village Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // ✅ First Row: State + District
                                Row(
                                  children: [
                                    Expanded(
                                      child: buildLocationTile(
                                        icon: Icons.flag,
                                        label: "State",
                                        value: session.stateName,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: buildLocationTile(
                                        icon: Icons.location_city,
                                        label: "District",
                                        value: session.districtName,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // ✅ Second Row: Block + GP
                                Row(
                                  children: [
                                    Expanded(
                                      child: buildLocationTile(
                                        icon: Icons.map,
                                        label: "Block",
                                        value: session.blockName,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: buildLocationTile(
                                        icon: Icons.groups,
                                        label: "GP",
                                        value: session.panchayatName,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // ✅ Third Row: Village (can add more if needed)
                                Row(
                                  children: [
                                    Expanded(
                                      child: buildLocationTile(
                                        icon: Icons.home,
                                        label: "Village",
                                        value: session.villageName,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: masterProvider.wtsFilterList
                                .where((source) => source.id != "5") // 👈 filter out ID 5
                                .map((source) {
                              return buildSampleCard(
                                title: source.sourceType,
                                color: Colors.primaries[masterProvider.wtsFilterList.indexOf(source) % Colors.primaries.length],
                                onTap: () {
                                  masterProvider.setSelectedWaterSourcefilter(source.id);
                                    Navigator.pushNamed(
                                      context,
                                      AppConstants.navigateToftkSampleInfoScreen,
                                      arguments:  {
                                        'sourceId': source.id,
                                        'sourceType': source.sourceType,
                                      }, // 👈 Pass the ID here
                                    );
                                },
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget buildLocationTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            radius: 16,
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSampleCard({
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color.withOpacity(0.5), width: 1.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.1),
                  ),
                  child: Image.asset(
                    'assets/icons/medical-lab.png',
                    width: 22,
                    height: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text(
                  "Add Sample",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(25, 40),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
