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
import '../../utils/VersionUtils.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  final LocalStorageService _localStorage = LocalStorageService();

  String stateName = '';
  String districtId = '';
  String userName = '';
  String mobile = '';
  String stateId = '';
  final encryption = AesEncryption();
late DashboardProvider dashboardProvider;
  @override
  void initState() {
    super.initState();
    var enc = encryption.encryptText("Beneficiaryname");
    print("Aesen-----> $enc");
    var dep = encryption.decryptText("lXYW81WigJhGmrXtPxd15g==");
    print("Aesen-----> $dep");

    getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      final masterProvider =
          Provider.of<Masterprovider>(context, listen: false);

      await dashboardProvider.loadDashboardData();
      print("dashboard ${dashboardProvider.isLoading}");
      print("master provider  data${masterProvider.isLoading}");

      await masterProvider.fetchDistricts(stateId);
      await masterProvider.fetchBlocks(stateId, districtId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/icons/header_bg.png'), fit: BoxFit.cover),
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
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh,
                        color: Colors.white),
                    // Cart icon
                    onPressed: () {
                      dashboardProvider.loadDashboardData();
                    },
                  )
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
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(
                    AppConstants.listOfSamples,
                    style: AppStyles.style16NormalBlack,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppConstants.navigateToSampleListScreen,
                        arguments: {
                          'flag': AppConstants.totalSamplesSubmitted,
                        });
                  },
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
                        context, AppConstants.navigateToLoginScreen);
                  },
                ),
              ],
            ),
          ),
          body: Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, child) {
              if (dashboardProvider.isLoading) {
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
                                  const AssetImage('assets/icons/user.png'),
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
                                  '${AppConstants.welcome},',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'OpenSans',
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
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
                                          fontFamily: 'OpenSans',
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

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
                                          fontFamily: 'OpenSans',
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
                    const SizedBox(height: 15),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFe0f7fa), Color(0xFFFFFFFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Row for School section
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/medical-lab.png',
                                  iconColor: Colors.blue,
                                  title: AppConstants.totalSamplesSubmitted,
                                  value:  '${dashboardProvider.dashboardData?.totalSamplesSubmitted ?? 0}',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        AppConstants.navigateToSampleListScreen,
                                        arguments: {
                                          'flag':
                                          AppConstants.totalSamplesSubmitted,
                                          'flagFloating': ""
                                        });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/test.png',
                                  iconColor: Colors.deepOrange,
                                  title:  AppConstants.totalPhysicalSubmitted,
                                  value:   '${dashboardProvider.dashboardData?.samplesPhysicallySubmitted ?? 0}',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        AppConstants.navigateToSampleListScreen,
                                        arguments: {
                                          'flag':
                                          AppConstants.totalPhysicalSubmitted,
                                          'flagFloating': ""
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Row for Anganwadi section
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/blood_tube.png',
                                  iconColor: Colors.green,
                                  title: AppConstants.totalSampleTested,
                                  value:   '${dashboardProvider.dashboardData?.totalSamplesTested ?? 0}',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        AppConstants.navigateToSampleListScreen,
                                        arguments: {
                                          'flag': AppConstants.totalSampleTested,
                                          'flagFloating': ""
                                        });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/search.png',
                                  iconColor: Colors.purple,
                                  title: "Know your sample detail",
                                  value:
                                  '',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        AppConstants.navigateToSampleListScreen,
                                        arguments: {
                                          'flag': AppConstants.totalSampleTested,
                                          'flagFloating': ""
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  /*  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 10.0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildMenuCard(
                                title: AppConstants.totalSamplesSubmitted,
                                icon: Icons.analytics,
                                gradientColors: [
                                  Colors.lightBlue,
                                  Colors.blueAccent
                                ],
                                value:
                                    '${dashboardProvider.dashboardData?.totalSamplesSubmitted ?? 0}',
                                imageName: 'medical-lab',
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      AppConstants.navigateToSampleListScreen,
                                      arguments: {
                                        'flag':
                                            AppConstants.totalSamplesSubmitted,
                                        'flagFloating': ""
                                      });
                                },
                              ),
                              _buildMenuCard(
                                title: AppConstants.totalPhysicalSubmitted,
                                icon: Icons.attach_money,
                                gradientColors: [
                                  Colors.deepOrange,
                                  Colors.orange
                                ],
                                value:
                                    '${dashboardProvider.dashboardData?.samplesPhysicallySubmitted ?? 0}',
                                imageName: 'test',
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      AppConstants.navigateToSampleListScreen,
                                      arguments: {
                                        'flag':
                                            AppConstants.totalPhysicalSubmitted,
                                        'flagFloating': ""
                                      });
                                },
                              ),
                              _buildMenuCard(
                                title: AppConstants.totalSampleTested,
                                icon: Icons.check_circle,
                                gradientColors: [Colors.teal, Colors.green],
                                value:
                                    '${dashboardProvider.dashboardData?.totalSamplesTested ?? 0}',
                                imageName: 'search',
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      AppConstants.navigateToSampleListScreen,
                                      arguments: {
                                        'flag': AppConstants.totalSampleTested,
                                        'flagFloating': ""
                                      });
                                },
                              ),
                                   _buildMenuCard(
                                  title: AppConstants.totalRetest,
                                  icon: Icons.refresh,
                                  gradientColors: [Colors.red, Colors.deepOrange],
                                  value: '${dashboardProvider.dashboardData?.totalRetest??0}',
                                  onTap: () {
                                    // Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': AppConstants.totalRetest});
                                    ToastHelper.showSnackBar(context, "Admin can access this option only");
                                  },
                                ),
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
                    ),*/
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                             showDialog<bool>(
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
                                      flag: AppConstants.openSampleInfoScreen,
                                      flagFloating: "",
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0468B1),
                            textStyle: const TextStyle(fontSize: 16),
                            minimumSize: const Size(300, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // ← removes rounding
                            ),
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
    required String imageName, // Renamed here
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(8), // Slightly increased for spacing
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/icons/$imageName.png',
                  width: 26, // Increased size
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  fontFamily: 'OpenSans',
                  shadows: [
                    Shadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoCard({
    required String imagePath,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    required String value,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 135,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: iconColor.withOpacity(0.6), // 🔹 Colored border
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: iconColor.withOpacity(0.6), // 🔹 Colored border
                  width: 1.2,
                ),
              ),
              child: Image.asset(
                imagePath,
                width: 32,
                height: 32,

              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: iconColor,
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
    districtId = _localStorage.getString(AppConstants.prefDistrictId) ?? '';
    print("token-------------- $token ----state naem$stateName");
    return token;
  }
}
