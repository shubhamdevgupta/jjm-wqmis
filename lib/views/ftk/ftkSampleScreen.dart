// views/DashboardScreen.dart
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/dashboardProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/Aesen.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';

class ftksamplescreen extends StatefulWidget {
  const ftksamplescreen({super.key});

  @override
  State<ftksamplescreen> createState() => _ftksamplescreen();
}

class _ftksamplescreen extends State<ftksamplescreen> {
  final LocalStorageService _localStorage = LocalStorageService();

  String stateName = '';
  String districtId = '';
  String userName = '';
  String mobile = '';
  String stateId = '';
  final encryption = AesEncryption();

  @override
  void initState() {
    super.initState();
    var enc = encryption.encryptText("Beneficiaryname");
    var dep = encryption.decryptText("lXYW81WigJhGmrXtPxd15g==");

    getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dashboardProvider =
      Provider.of<DashboardProvider>(context, listen: false);
      final masterProvider =
      Provider.of<Masterprovider>(context, listen: false);

      await dashboardProvider.loadDashboardData();

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
                        AppConstants.ftkUser,
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
                    AppConstants.totalSamplesalreadytested,
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

                    const SizedBox(height: 20),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 🔹 Metric Card




                        // 🔸 Location White Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildLocationTile(
                                      icon: Icons.location_city,
                                      label: "District",
                                      value: "Jaipur",
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: buildLocationTile(
                                      icon: Icons.map,
                                      label: "Block",
                                      value: "Sanganer",
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildLocationTile(
                                      icon: Icons.groups,
                                      label: "GP",
                                      value: "Mansarovar",
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: buildLocationTile(
                                      icon: Icons.home,
                                      label: "Village",
                                      value: "Pratap Nagar",
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            buildSampleCard(
                              title: "Total no. Source of Schemes",
                              count: "425",
                              color: Colors.green,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.navigateToSampleListScreen,
                                  arguments: {
                                    'flag': AppConstants.totalSamplesSubmitted,
                                    'flagFloating': "",
                                  },
                                );
                              },
                            ),
                            buildSampleCard(
                              title: "Storage Structure",
                              count: "425",
                              color: Colors.blue,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.navigateToSampleListScreen,
                                  arguments: {
                                    'flag': AppConstants.totalSamplesSubmitted,
                                    'flagFloating': "",
                                  },
                                );
                              },
                            ),
                            buildSampleCard(
                              title: "Households/School/AWCs",
                              count: "425",
                              color: Colors.deepOrange,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.navigateToSampleListScreen,
                                  arguments: {
                                    'flag': AppConstants.totalSamplesSubmitted,
                                    'flagFloating': "",
                                  },
                                );
                              },
                            ),
                            buildSampleCard(
                              title: "Handpumps and other private sources",
                              count: "425",
                              color: Colors.purple,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.navigateToSampleListScreen,
                                  arguments: {
                                    'flag': AppConstants.totalSamplesSubmitted,
                                    'flagFloating': "",
                                  },
                                );
                              },
                            ),
                          ],
                        ),


                      ],
                    ),





                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {

                            Navigator.pushReplacementNamed(context, AppConstants.navigateToDashboardScreen);
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
                                AppConstants.addftk,
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
    required String count,
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
                  minimumSize: const Size(10, 10),
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




  String getToken() {
    String? token = _localStorage.getString(AppConstants.prefToken) ?? '';
    stateName = _localStorage.getString(AppConstants.prefStateName) ?? '';
    userName = _localStorage.getString(AppConstants.prefName) ?? '';
    mobile = _localStorage.getString(AppConstants.prefMobile) ?? '';
    stateId = _localStorage.getString(AppConstants.prefStateId) ?? '';
    districtId = _localStorage.getString(AppConstants.prefDistrictId) ?? '';
    return token;
  }
}


