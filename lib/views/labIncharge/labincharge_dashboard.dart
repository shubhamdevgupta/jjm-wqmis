import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/services/app_reset_service.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:provider/provider.dart';

class LabinchargeDashboard extends StatefulWidget {
  const LabinchargeDashboard({super.key});

  @override
  State<LabinchargeDashboard> createState() => _LabinchargeDashboardState();
}

class _LabinchargeDashboardState extends State<LabinchargeDashboard> {
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
          title: const Text('Dashboard (2025-2026)',style: TextStyle(color: Colors.white),),
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

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top 4 summary boxes in 2x2 layout using Wrap for responsiveness
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildDashboardCard(
                    icon: Icons.water_drop,
                    color: Colors.blue.shade700,
                    label: 'NEW SAMPLES TESTED',
                    value: '3',
                  ),
                  _buildDashboardCard(
                    icon: Icons.fact_check,
                    color: Colors.orange,
                    label: 'SAMPLES TESTED APPROVED',
                    value: '1145',
                  ),
                  _buildDashboardCard(
                    icon: Icons.warning,
                    color: Colors.red.shade600,
                    label: 'CONTAMINATED',
                    value: '284',
                  ),
                  _buildDashboardCard(
                    icon: Icons.check_circle,
                    color: Colors.green.shade600,
                    label: 'REMEDIAL ACTION',
                    value: '200',
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Laboratory Service Area
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'LABORATORY SERVICE AREA',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildLabInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width < 600
          ? double.infinity
          : (MediaQuery.of(context).size.width / 2) - 32,
      child: Card(
        elevation: 3,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  SizedBox(width: 20,),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabInfo() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Lab name",
              "State Level Water Analysis Laboratory, U.P Jal Nigam (Rural), Lucknow"),
          _buildInfoRow("Lab group", "STATE LEVEL"),
          _buildInfoRow("Lab address", "6 Rana pratap Marg Lucknow"),
          Row(
            children: [
              const Text(
                "Service area:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: (){}, child: Text("View")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
