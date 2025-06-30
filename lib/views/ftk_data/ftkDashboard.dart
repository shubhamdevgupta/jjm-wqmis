// views/DashboardScreen.dart
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/providers/ftkProvider.dart';
import 'package:jjm_wqmis/services/AppResetService.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:provider/provider.dart';

class ftkDashboard extends StatefulWidget {
  const ftkDashboard({super.key});

  @override
  State<ftkDashboard> createState() => _ftkDashboard();
}

class _ftkDashboard extends State<ftkDashboard> {
  final session = UserSessionManager();
  int? villageId;
  int? regId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.init();
      await Provider.of<Ftkprovider>(context, listen: false)
          .fetchFtkDashboardData(session.regId, session.villageId);
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
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  // Cart icon
                  onPressed: () {
                    Provider.of<Ftkprovider>(context, listen: false)
                        .fetchFtkDashboardData(
                            session.regId, session.villageId);
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
                      AppConstants.ftkUser,
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
            ],
          ),
        ),
        body: Consumer2<AuthenticationProvider, Ftkprovider>(
          builder: (context, authProvider, ftkProvider, child) {
            return ftkProvider.isLoading
                ? LoaderUtils.conditionalLoader(
                    isLoading: ftkProvider.isLoading)
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 2),
                          padding: const EdgeInsets.all(5),
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
                                          'FTK User',
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
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

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
                                      const SizedBox(width: 8),
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
                                  const SizedBox(height: 8),

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
                                      const SizedBox(width: 8),
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
                                  const SizedBox(height: 8),

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
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.navigateToFtkSampleListScreen,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.lightGreen, Colors.green],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueAccent.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.white24),
                                      ),
                                      child: Image.asset(
                                        'assets/icons/medical-lab.png',
                                        width: 22,
                                        height: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            AppConstants.totalSamplesalreadytested,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          //SizedBox(height: 4),
                                          //fix thi
                                          Text(
                                            '${ftkProvider.ftkDashboardResponse?.totalSampleTested}',
                                            // 🔹 Static value
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "This figure are based on current year data.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                print(
                                    '----------->>>  ${AppConstants.navigateToFtkSampleScreen}');
                                Navigator.pushReplacementNamed(context,
                                    AppConstants.navigateToFtkSampleScreen);
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
        ),
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
      padding: const EdgeInsets.all(8),
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
          const SizedBox(width: 6),
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
                    fontSize: 13,
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
}
