// views/DashboardScreen.dart
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/dashboardProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/Aesen.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/views/LocationScreen.dart';
import 'package:provider/provider.dart';

import '../../services/LocalStorageService.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  final LocalStorageService _localStorage = LocalStorageService();
  String stateName = '';
  String userName = '';
  String mobile = '';
  String stateId = '';
  final encryption = AesEncryption();

  @override
  void initState() {
    super.initState();

    var enc = encryption.encryptText("Beneficiaryname");
    print("Aesen-----> $enc");
    var dep = encryption.decryptText("lXYW81WigJhGmrXtPxd15g==");
    print("Aesen-----> $dep");

    getToken();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
      final masterProvider = Provider.of<Masterprovider>(context, listen: false);

      dashboardProvider.loadDashboardData();

      masterProvider.clearData();
      masterProvider.fetchDistricts(stateId);
    });


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // Removes the default back button
            centerTitle: true,
            title:  const Text(
              AppConstants.appTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  // Drawer icon
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open the Navigation Drawer
                  },
                );
              },
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_active,
                        color: Colors.white),
                    onPressed: () {
                    },
                  ),
                ],
              ),
            ],
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

          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration:  const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      const Text(
                        AppConstants.departmentalUser,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        stateName,  // Provide a fallback value if null
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text(AppConstants.dashboard),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(AppConstants.submitSampleInfo),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppConstants.navigateToSaveSample);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(AppConstants.listOfSamples),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppConstants.navigateToSampleList);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text(AppConstants.maintenance),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(AppConstants.logout),
                  onTap: () async {
                    final authProvider = Provider.of<AuthenticationProvider>(
                        context,
                        listen: false);
                    await authProvider.logoutUser();
                    Navigator.pushReplacementNamed(context, AppConstants.navigateToLogin);
                  },
                ),
              ],
            ),
          ),
          body: Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, child) {
              final dashboardData = dashboardProvider.dashboardData;

              if (dashboardData == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        AppConstants.dashboardOverview,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      margin: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Circular user image
                          CircleAvatar(
                            radius: 32,
                            backgroundImage:
                            const AssetImage('assets/user_image.png'),
                            // Replace with dynamic user profile image path
                            backgroundColor: Colors.grey[200], // Fallback color
                          ),
                          const SizedBox(width: 16), // Space between image and text

                          // Text column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Welcome message
                                Text(
                                  '${AppConstants.welcome}, $userName',
                                  // Replace with dynamic username
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[800],
                                    // Slightly dark blue color for warmth
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.5,
                                  ),
                                ),

                                const SizedBox(height: 8), // Space between lines

                                // Phone Row
                                Row(
                                  children: [
                                    const Icon(Icons.phone_android,
                                        color: Colors.teal, size: 20),
                                    // Using an icon for consistency
                                    const SizedBox(width: 6),
                                    Text(
                                      '$mobile',
                                      // Replace with dynamic phone number
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.account_balance_sharp,
                                        color: Colors.teal, size: 20),
                                    // Using an icon for consistency
                                    const SizedBox(width: 6),
                                    Text(
                                      'Departmental Official',
                                      // Replace with dynamic phone number
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                  Center(child: const Text("All figures are based on current year data.",style: TextStyle(fontSize: 15,color: Colors.red),)),

                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildDashboardCard(
                          title: AppConstants.totalSamplesSubmitted,
                          value: '${dashboardProvider.dashboardData!.totalSamplesSubmitted}',
                          icon: Icons.analytics,
                          gradientColors: [
                            Colors.lightBlueAccent,
                            Colors.blue
                          ],
                          onTap: () {
                            Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': 0});
                          },
                        ),
                        _buildDashboardCard(
                          title: AppConstants.totalPhysicalSubmitted,
                          value: '${dashboardProvider.dashboardData!.samplesPhysicallySubmitted}',
                          icon: Icons.hourglass_empty,
                          gradientColors: [
                            const Color(0xFFFCE889),
                            const Color(0xFFFFAA00)
                          ],
                          onTap: () {
                            Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': 2});
                          },
                        ),
                        _buildDashboardCard(
                          title: AppConstants.totalSampleTested,
                          value: '${dashboardProvider.dashboardData!.totalSamplesTested}',
                          icon: Icons.check_circle,
                          gradientColors: [
                            Colors.lightGreen,
                            Colors.green
                          ],
                          onTap: () {
                            Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': 6});
                          },
                        ),
                        _buildDashboardCard(
                          title: AppConstants.totalRetest,
                          value: '${dashboardProvider.dashboardData!.totalRetest}',
                          icon: Icons.refresh,
                          gradientColors: [
                            Colors.redAccent,
                            Colors.red
                          ],
                          onTap: () {
                            Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': 8});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await showDialog<bool>( // <- await and expecting result now
                            context: context,
                            builder: (BuildContext context) {
                              double screenHeight = MediaQuery.of(context).size.height;
                              double screenwidth = MediaQuery.of(context).size.width;

                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(10),
                                content: Container(
                                  color: Colors.white,
                                  height: screenHeight * 0.8,
                                  width: screenwidth * 0.99,
                                  child: const Locationscreen(flag: 0), // Your widget
                                ),
                              );
                            },
                          );
                          if (result == false) {
                            Provider.of<Masterprovider>(context, listen: false).clearData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0468B1),
                          textStyle: const TextStyle(fontSize: 16),
                          minimumSize: const Size(300, 50),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              AppConstants.addSample,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradientColors, // Gradient colors as List
    required VoidCallback onTap, // Added onTap callback
  }) {
    return GestureDetector(
      onTap: onTap, // Trigger onTap when the card is tapped
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getToken() {
    String? token = _localStorage.getString(AppConstants.prefToken) ?? '';
    stateName = _localStorage.getString(AppConstants.prefStateName) ?? '';
    userName = _localStorage.getString(AppConstants.prefName) ?? '';
    mobile = _localStorage.getString(AppConstants.prefMobile) ?? '';
    stateId = _localStorage.getString(AppConstants.prefStateId) ?? '';
    print("token-------------- $token ----state naem$stateName");
    return token;
  }
}
