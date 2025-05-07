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
import '../../utils/AppStyles.dart';

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
      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      final masterProvider =
          Provider.of<Masterprovider>(context, listen: false);

      dashboardProvider.loadDashboardData();
      print("dashboard data${dashboardProvider.dashboardData}");

   //   masterProvider.clearData();
      masterProvider.fetchDistricts(stateId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/header_bg.png'), fit: BoxFit.cover),
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
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  // Drawer icon
                  onPressed: () {
                    Scaffold.of(context)
                        .openDrawer(); // Open the Navigation Drawer
                  },
                );
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.departmentalUser,
                        style: AppStyles.appBarTitle,
                      ),
                      Text(
                        stateName, // Provide a fallback value if null
                        style: AppStyles.setTextStyle(
                            16, FontWeight.normal, Colors.white70),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: Text(
                    AppConstants.dashboard,
                    style: AppStyles.style16NormalBlack,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(
                    AppConstants.submitSampleInfo,
                    style: AppStyles.style16NormalBlack,
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppConstants.navigateToSaveSample);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(
                    AppConstants.listOfSamples,
                    style: AppStyles.style16NormalBlack,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppConstants.navigateToSampleList,
                        arguments: {
                          'flag': AppConstants.totalSamplesSubmitted,
                        });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(
                    AppConstants.maintenance,
                    style: AppStyles.style16NormalBlack,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(
                    AppConstants.logout,
                    style: AppStyles.style16NormalBlack,
                  ),
                  onTap: () async {
                    final authProvider = Provider.of<AuthenticationProvider>(
                        context,
                        listen: false);
                    await authProvider.logoutUser();
                    Navigator.pushReplacementNamed(
                        context, AppConstants.navigateToLogin);
                  },
                ),
              ],
            ),
          ),
          body: Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, child) {
              final dashboardData = dashboardProvider.dashboardData;
              print("dashboard data ${dashboardData}");
              if (dashboardData == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Profile Picture
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade300,
                                  Colors.blue.shade800
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(2),
                            // Border-like effect
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey[100],
                              backgroundImage:
                                  const AssetImage('assets/user.png'),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Welcome Text
                                Text(
                                  '${AppConstants.welcome}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade700,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontFamily: 'Poppins',
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // Department and Phone
                                Row(
                                  children: [
                                    const Icon(Icons.account_balance_sharp,
                                        size: 18, color: Colors.teal),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Departmental User',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    const Icon(Icons.phone_android,
                                        size: 18, color: Colors.teal),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        mobile,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 15.0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.4, // Adjust this to control card height
                          children: [
                            _buildMenuCard(
                              title: AppConstants.totalSamplesSubmitted,
                              icon: Icons.analytics,
                              gradientColors: [
                                Colors.lightBlue,
                                Colors.blueAccent
                              ],
                              value:
                                  '${dashboardProvider.dashboardData!.totalSamplesSubmitted}',
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppConstants.navigateToSampleList,
                                    arguments: {
                                      'flag':
                                          AppConstants.totalSamplesSubmitted,
                                    });
                              },
                            ),
                            _buildMenuCard(
                              title: AppConstants.totalPhysicalSubmitted,
                              icon: Icons.attach_money,
                              gradientColors: [Colors.amber, Colors.orange],
                              value:
                                  '${dashboardProvider.dashboardData!.samplesPhysicallySubmitted}',
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppConstants.navigateToSampleList,
                                    arguments: {
                                      'flag':
                                          AppConstants.totalPhysicalSubmitted
                                    });
                              },
                            ),
                            _buildMenuCard(
                              title: AppConstants.totalSampleTested,
                              icon: Icons.check_circle,
                              gradientColors: [Colors.teal, Colors.green],
                              value:
                                  '${dashboardProvider.dashboardData!.totalSamplesTested}',
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppConstants.navigateToSampleList,
                                    arguments: {
                                      'flag': AppConstants.totalSampleTested
                                    });
                              },
                            ),
                            /*       _buildMenuCard(
                                title: AppConstants.totalRetest,
                                icon: Icons.refresh,
                                gradientColors: [Colors.red, Colors.deepOrange],
                                value: '${dashboardProvider.dashboardData!.totalRetest}',
                                onTap: () {
                                 // Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': AppConstants.totalRetest});
                                  ToastHelper.showSnackBar(context, "Admin can access this option only");
                                },
                              ),*/
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: const Text(
                            "All figures are based on current year data.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              double screenHeight =
                                  MediaQuery.of(context).size.height;
                              double screenwidth =
                                  MediaQuery.of(context).size.width;

                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(10),
                                content: Container(
                                  color: Colors.white,
                                  height: screenHeight * 0.8,
                                  width: screenwidth * 0.99,
                                  child: const Locationscreen(
                                      flag: AppConstants
                                          .openSampleInfoScreen), // Your widget
                                ),
                              );
                            },
                          );
                        /*  if (result == false) {
                            Provider.of<Masterprovider>(context, listen: false)
                                .clearData();
                          }*/
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
                              style: AppStyles.textStyle,
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

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3,
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
