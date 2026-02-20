// views/DashboardScreen.dart
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/dashboard_provider.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/services/app_reset_service.dart';
import 'package:jjm_wqmis/utils/AppUtil.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/encyp_decyp.dart';
import 'package:jjm_wqmis/utils/location/current_location.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/dept_data/sampleinfo/location_screen.dart';
import 'package:provider/provider.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  final session = UserSessionManager();

  final encryption = AesEncryption();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.init();
     await CurrentLocation.refresh();
      print("------->> ${CurrentLocation.longitude}");
      Provider.of<DashboardProvider>(context, listen: false)
          .loadDashboardData(session.roleId, session.regId, session.stateId);
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
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    // Cart icon
                    onPressed: () {
                      Provider.of<DashboardProvider>(context, listen: false)
                          .loadDashboardData(
                              session.roleId, session.regId, session.stateId);
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
                        session.stateName, // Provide a fallback value if null
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
                  onTap: () async {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 200));
                    showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        double screenHeight =
                            MediaQuery.of(context).size.height;
                        double screenwidth = MediaQuery.of(context).size.width;
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
                    await AppResetService.fullReset(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppConstants.navigateToLoginScreen,
                      (route) => false,
                    );
                  },
                ),
                ListTile(
                  title: Text("v${AppUtil.appVersion}",
                  ),
                ),
              ],
            ),
          ),
          body: Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, child) {
              final masterProvider =
                  Provider.of<Masterprovider>(context, listen: false);
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
                                  session.userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // Department and Phone
                                const Row(
                                  children: [
                                    Icon(Icons.account_balance_sharp,
                                        size: 18, color: Colors.teal),
                                    SizedBox(width: 6),
                                    Text(
                                      'Departmental User',
                                      style: TextStyle(
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
                                        session.mobile,
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
                      padding: const EdgeInsets.all(10),
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
                                  value:
                                      '${dashboardProvider.dashboardData?.totalSamplesSubmitted ?? 0}',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        AppConstants.navigateToSampleListScreen,
                                        arguments: {
                                          'flag': AppConstants
                                              .totalSamplesSubmitted,
                                          'flagFloating':
                                              AppConstants.totalSamplesSubmitted
                                        });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/test.png',
                                  iconColor: Colors.deepOrange,
                                  title: AppConstants.totalPhysicalSubmitted,
                                  value:
                                      '${dashboardProvider.dashboardData?.samplesPhysicallySubmitted ?? 0}',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        AppConstants.navigateToSampleListScreen,
                                        arguments: {
                                          'flag': AppConstants
                                              .totalPhysicalSubmitted,
                                          'flagFloating': AppConstants
                                              .totalPhysicalSubmitted
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
                                  value:
                                      '${dashboardProvider.dashboardData?.totalSamplesTested ?? 0}',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        AppConstants.navigateToSampleListScreen,
                                        arguments: {
                                          'flag':
                                              AppConstants.totalSampleTested,
                                          'flagFloating':
                                              AppConstants.totalSampleTested
                                        });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/search.png',
                                  iconColor: Colors.purple,
                                  title: AppConstants.knowyoursampledetail,
                                  value: '',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        AppConstants.navigateToSampleListScreen,
                                        arguments: {
                                          'flag':
                                              AppConstants.knowyoursampledetail,
                                          'flagFloating':
                                              AppConstants.knowyoursampledetail
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await masterProvider.fetchBlocks(
                                session.stateId.toString(),
                                session.districtId.toString(),
                                session.regId);
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
              padding: const EdgeInsets.all(8),
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
                fontSize: 13,
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
}
