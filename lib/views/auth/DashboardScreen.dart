import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication_provider.dart';
import '../../providers/dashboardProvider.dart';
import '../../providers/masterProvider.dart';
import '../../services/LocalStorageService.dart';
import '../../utils/AppConstants.dart';
import '../LocationScreen.dart';

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
  String userDept = '';

  @override
  void initState() {
    super.initState();
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
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/header_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            AppConstants.appTitle,
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
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
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF096DA8), Color(0xFF3C8DBC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          elevation: 5,
        ),
        drawer: NavigationDrawer(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppConstants.departmentalUser, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(stateName, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, AppConstants.dashboard, () {
              Navigator.pop(context);
            }),
            _buildDrawerItem(Icons.list, AppConstants.submitSampleInfo, () {
              Navigator.pushReplacementNamed(context, AppConstants.navigateToSaveSample);
            }),
            _buildDrawerItem(Icons.list, AppConstants.listOfSamples, () {
          //    Navigator.pushReplacementNamed(context, AppConstants.navigateToSampleList);
              Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': AppConstants.totalSamplesSubmitted});
            }),
            _buildDrawerItem(Icons.settings, AppConstants.maintenance, () {}),
            _buildDrawerItem(Icons.logout, AppConstants.logout, () async {
              final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
              await authProvider.logoutUser();
              Navigator.pushReplacementNamed(context, AppConstants.navigateToLogin);
            }),
          ],
        ),
        body: Consumer<DashboardProvider>(
          builder: (context, dashboardProvider, _) {
            final dashboardData = dashboardProvider.dashboardData;

            if (dashboardData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(theme),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      "All figures are based on current year data.",
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _buildDashboardCard(
                        title: AppConstants.totalSamplesSubmitted,
                        value: '${dashboardData.totalSamplesSubmitted}',
                        icon: Icons.analytics,
                        gradientColors: [Colors.blue.shade300, Colors.blue.shade700],
                        onTap: () {
                          Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': AppConstants.totalSamplesSubmitted});
                        },
                      ),
                      _buildDashboardCard(
                        title: AppConstants.totalPhysicalSubmitted,
                        value: '${dashboardData.samplesPhysicallySubmitted}',
                        icon: Icons.hourglass_empty,
                        gradientColors: [Colors.amber.shade200, Colors.orange.shade600],
                        onTap: () {
                          Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': AppConstants.totalPhysicalSubmitted});
                        },
                      ),
                      _buildDashboardCard(
                        title: AppConstants.totalSampleTested,
                        value: '${dashboardData.totalSamplesTested}',
                        icon: Icons.check_circle,
                        gradientColors: [Colors.green.shade300, Colors.green.shade700],
                        onTap: () {
                          Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': AppConstants.totalSampleTested});
                        },
                      ),
                      _buildDashboardCard(
                        title: AppConstants.totalRetest,
                        value: '${dashboardData.totalRetest}',
                        icon: Icons.refresh,
                        gradientColors: [Colors.redAccent, Colors.red],
                        onTap: () {
                          Navigator.pushNamed(context, AppConstants.navigateToSampleList, arguments: {'flag': AppConstants.totalRetest});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: FilledButton.icon(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            double screenHeight = MediaQuery.of(context).size.height;
                            double screenWidth = MediaQuery.of(context).size.width;
                            return AlertDialog(
                              contentPadding: const EdgeInsets.all(8),
                              content: Container(
                                height: screenHeight * 0.8,
                                width: screenWidth * 0.95,
                                color: Colors.white,
                                child: const Locationscreen(flag: AppConstants.openSampleInfoScreen),
                              ),
                            );
                          },
                        );
                        if (result == false) {
                          Provider.of<Masterprovider>(context, listen: false).clearData();
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0468B1),
                        minimumSize: const Size(300, 50),
                        textStyle: theme.textTheme.titleMedium,
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(AppConstants.addSample),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: const AssetImage('assets/user.png'),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppConstants.welcome}, $userName',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.blue.shade900),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.account_balance_sharp, size: 18, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(
                        userDept == "4" ? 'Departmental Official' : userDept == "8" ? 'DWSM' : 'Unknown Department',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.phone_android, size: 18, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(mobile, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      onTap: onTap,
    );
  }

  void getToken() {
    String? token = _localStorage.getString(AppConstants.prefToken) ?? '';
    stateName = _localStorage.getString(AppConstants.prefStateName) ?? '';
    userName = _localStorage.getString(AppConstants.prefName) ?? '';
    mobile = _localStorage.getString(AppConstants.prefMobile) ?? '';
    stateId = _localStorage.getString(AppConstants.prefStateId) ?? '';
    userDept = _localStorage.getString(AppConstants.prefRoleId) ?? '';
    debugPrint("Token: $token, State: $stateName");
  }
}
