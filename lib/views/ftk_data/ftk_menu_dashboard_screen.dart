// views/DashboardScreen.dart
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ftk_provider.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:provider/provider.dart';

class Ftkmenudashboardscreen extends StatefulWidget {
  const Ftkmenudashboardscreen({super.key});

  @override
  State<Ftkmenudashboardscreen> createState() => _ftkMenuDashboardScreen();
}

class _ftkMenuDashboardScreen extends State<Ftkmenudashboardscreen> {
  final session = UserSessionManager();
  Map<String, int>? sampleCounts;
  final List<Color> balancedColors = [
    const Color(0xFFFFB74D), // 🔶 Light Orange – your warm, only light shade
    const Color(0xFF42A5F5), // 🔵 Medium Blue – professional and calm
    const Color(0xFF66BB6A), // 🟢 Medium Green – fresh and natural
    const Color(0xFFAB47BC), // 🟣 Medium Purple – elegant and refined
    const Color(0xFF5C6BC0), // 🔷 Indigo – strong but not too dark
    const Color(0xFF26A69A), // 🧊 Cyan-Green – cool alternative to teal
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.init();

      final masterProvider =
          Provider.of<Masterprovider>(context, listen: false);
      await masterProvider.fetchWatersourcefilterList(session.regId);
      sampleCounts = Provider.of<Ftkprovider>(context, listen: false).getSampleCountsMap();
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
                return masterProvider.isLoading
                    ? LoaderUtils.conditionalLoader(
                        isLoading: masterProvider.isLoading)
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              size: 18,
                                              color: Colors.redAccent),
                                          SizedBox(width: 6),
                                          Text(
                                            "Village Details",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: [
                                          _info("State", session.stateName),
                                          _arrow(),
                                          _info(
                                              "District", session.districtName),
                                          _arrow(),
                                          _info("Block", session.blockName),
                                          _arrow(),
                                          _info("GP", session.panchayatName),
                                          _arrow(),
                                          _info("Village", session.villageName),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                sampleCounts == null
                                    ? LoaderUtils.conditionalLoader(
                                        isLoading: sampleCounts == null)
                                    : Column(
                                        children: masterProvider.wtsFilterList
                                            .where((source) =>
                                                source.id !=
                                                "5") // Exclude ID 5
                                            .map((source) {
                                          final colorIndex = masterProvider
                                                  .wtsFilterList
                                                  .indexOf(source) %
                                              balancedColors.length;

                                          final cardColor =
                                              balancedColors[colorIndex];

                                          final count =
                                              sampleCounts![source.id] ?? 0;

                                          return buildSampleCard(
                                            title: source.sourceType,
                                            color: cardColor,
                                            count: count.toString(),
                                            onTap: (count) {
                                              if (count.isNotEmpty) {
                                                masterProvider
                                                    .setSelectedWaterSourcefilter(
                                                        source.id);
                                                Navigator.pushNamed(
                                                  context,
                                                  AppConstants
                                                      .navigateToftkSampleInfoScreen,
                                                  arguments: {
                                                    'sourceId': source.id,
                                                    'sourceType':
                                                        source.sourceType,
                                                  },
                                                );
                                              }
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

  Widget _info(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
              fontSize: 12, color: Colors.teal, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 12.5,
              color: Colors.black87,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _arrow() {
    return Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey[500]);
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
    required Function(String count) onTap,
    required String count,
    required Color color,
  }) {
    final bool isDisabled = count == "0";

    Widget cardContent = Opacity(
      opacity: isDisabled ? 0.7 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : () => onTap(count),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
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
                  const SizedBox(width: 8),
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
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: isDisabled ? null : () => onTap(count),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    "Add Sample",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: color,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      ),
    );

    return isDisabled
        ? Tooltip(
            message: "No samples available",
            child: cardContent,
          )
        : cardContent;
  }
}
