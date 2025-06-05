// views/DashboardScreen.dart
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/dwsmProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/views/DWSM/DwsmLocationScreen.dart';
import 'package:jjm_wqmis/views/DWSM/dwsmList/DemonstrationScreen.dart';
import 'package:jjm_wqmis/views/DWSM/dwsmList/SchoolAwcScreen.dart';

class Dwsdashboardscreen extends StatefulWidget {
  const Dwsdashboardscreen({super.key});

  @override
  State<Dwsdashboardscreen> createState() => dwsmDashboardScreen();
}

class dwsmDashboardScreen extends State<Dwsdashboardscreen> {
  final LocalStorageService _localStorage = LocalStorageService();
  String stateName = '';
  String userName = '';
  String userID = '';
  String mobile = '';
  String stateId = '';
  String districtId = '';
  late DwsmProvider dashboardProvider;

  @override
  void initState() {
    super.initState();

    getToken();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dashboardProvider = Provider.of<DwsmProvider>(context, listen: false);
      final masterProvider =
          Provider.of<Masterprovider>(context, listen: false);
      await dashboardProvider.fetchDwsmDashboard(int.parse(userID));
      //   masterProvider.clearData();
      await masterProvider.fetchDistricts(stateId);
      await masterProvider.fetchBlocks(stateId, districtId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/icons/wqmis_bg_neeraj.jpeg'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // Removes the default back button
            centerTitle: true,
            title: const Text(
              AppConstants.appTitle,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                    onPressed: () async {
                      await dashboardProvider
                          .fetchDwsmDashboard(int.parse(userID));
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
                      const Text(
                        "DWSM Official",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      Text(
                        stateName, // Provide a fallback value if null
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                        ),
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
                  title: const Text(AppConstants.listOfDemonstration),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppConstants.navigateToDemonstrationScreen);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(AppConstants.logout),
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
          body: Consumer<DwsmProvider>(
            builder: (context, dwsmDashboardProvider, child) {
              if (dwsmDashboardProvider.dwsmdashboardresponse == null ||
                  dwsmDashboardProvider.isLoading) {
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

                                const SizedBox(height: 8),

                                // Department and Phone
                                const Row(
                                  children: [
                                    Icon(Icons.account_balance_sharp,
                                        size: 18, color: Colors.teal),
                                    SizedBox(width: 6),
                                    Text(
                                      'DWSM User',
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
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width < 400 ? 12 : 20,
                      ),
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
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/school.png',
                                  iconColor: Colors.blue,
                                  title: "Total\nSchools",
                                  value:
                                      '${dwsmDashboardProvider.dwsmdashboardresponse?.totalSchools ?? 0}',
                                  onTap: () {
                                    if (dwsmDashboardProvider
                                            .dwsmdashboardresponse!
                                            .totalSchools >
                                        0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                            value: dwsmDashboardProvider,
                                            child:
                                                const SchoolAWCScreen(type: 10),
                                          ),
                                        ),
                                      );
                                    } else {
                                      ToastHelper.showSnackBar(context,
                                          "There is no school available for this user");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/presentation.png',
                                  iconColor: Colors.deepOrange,
                                  title: "School FTK Demonstrations",
                                  value:
                                      '${dwsmDashboardProvider.dwsmdashboardresponse?.totalSchoolsDemonstration ?? 0}',
                                  onTap: () {
                                    if (dwsmDashboardProvider
                                            .dwsmdashboardresponse!
                                            .totalSchoolsDemonstration >
                                        0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                            value: dwsmDashboardProvider,
                                            child:
                                                const Demonstrationscreen(type: 10),
                                          ),
                                        ),
                                      );
                                    } else {
                                      ToastHelper.showSnackBar(context,
                                          "There is no demonstrated school");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/anganbadi.png',
                                  iconColor: Colors.green,
                                  title: "Total\nAnganwadi",
                                  value:
                                      '${dwsmDashboardProvider.dwsmdashboardresponse?.totalAWCs ?? 0}',
                                  onTap: () {
                                    if (dwsmDashboardProvider
                                            .dwsmdashboardresponse!.totalAWCs >
                                        0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                            value: dwsmDashboardProvider,
                                            child:
                                                const SchoolAWCScreen(type: 11),
                                          ),
                                        ),
                                      );
                                    } else {
                                      ToastHelper.showToastMessage(
                                          "There is no Anganwadi available for this user");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  imagePath: 'assets/icons/presentation.png',
                                  iconColor: Colors.red,
                                  title: "Anganwadi FTK Demonstrations",
                                  value:
                                      '${dwsmDashboardProvider.dwsmdashboardresponse?.totalAWCsDemonstration ?? 0}',
                                  onTap: () {
                                    if (dwsmDashboardProvider
                                            .dwsmdashboardresponse!
                                            .totalAWCsDemonstration >
                                        0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                            value: dwsmDashboardProvider,
                                            child:
                                                const Demonstrationscreen(type: 11),
                                          ),
                                        ),
                                      );
                                    } else {
                                      ToastHelper.showSnackBar(context,
                                          "There is no demonstrated AWCs");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog<bool>(
                            // <- await and expecting result now
                            context: context,
                            builder: (BuildContext context) {
                              double screenHeight =
                                  MediaQuery.of(context).size.height;
                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(10),
                                content: Container(
                                  color: Colors.white,
                                  height: screenHeight * 0.8,
                                  width: screenHeight * 0.4,
                                  child: const DwsmLocation(), // Your widget
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
                            borderRadius:
                                BorderRadius.circular(8), // ← removes rounding
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
                              AppConstants.addSchool,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'OpenSans'),
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

/*
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    required String value,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 135,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

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
    userID = _localStorage.getString(AppConstants.prefRegId) ?? '';
    districtId = _localStorage.getString(AppConstants.prefDistrictId) ?? '';
    print("token-------------- $token ----state naem$stateName");
    return token;
  }
}
