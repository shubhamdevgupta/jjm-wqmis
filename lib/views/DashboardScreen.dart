// views/DashboardScreen.dart
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/views/LocationScreen.dart';
import 'package:jjm_wqmis/views/SampleInformationScreen.dart';
import 'package:provider/provider.dart';

import '../services/LocalStorageService.dart';

class DashboardScreen extends StatelessWidget {
  final LocalStorageService _localStorage = LocalStorageService();
  @override
  Widget build(BuildContext context) {
    getToken();
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
        title: const Text(
          'JJM-WQMIS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        //Navigation Drawer Icon
        leading: Builder(
          // Add menu button to open the drawer
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

        //Notification badge icon
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_active,
                    color: Colors.white),
                onPressed: () {
                  // Handle notification button click
                  // if(unReadNotificationCount ==0){
                  //   CustomSnackBar.showError(context, 'There is no notifications found!');
                  // }else{
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => NotificationListScreenNew()),
                  //   );
                  // }

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => NotificationListScreen()),
                  // );
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
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Departmental User',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      'Uttar Pradesh',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Submit Sample Info '),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/savesample');
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('List of Samples'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Maintenance'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async{
                  final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);

                  await authProvider.logoutUser();

                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: const Text(
                  'Dashboard Overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circular user image
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('assets/user_image.png'), // Replace with dynamic user profile image path
                      backgroundColor: Colors.grey[200], // Fallback color
                    ),
                    SizedBox(width: 16), // Space between image and text

                    // Text column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome message
                          Text(
                            'Welcome, Ajay', // Replace with dynamic username
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[800], // Slightly dark blue color for warmth
                              fontFamily: 'Poppins',
                              letterSpacing: 0.5,
                            ),
                          ),

                          SizedBox(height: 8), // Space between lines

                          // Phone Row
                          Row(
                            children: [
                              Icon(Icons.phone_android, color: Colors.teal, size: 20), // Using an icon for consistency
                              SizedBox(width: 6),
                              Text(
                                '9599460671', // Replace with dynamic phone number
                                style: TextStyle(
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
              const SizedBox(height: 15),





              const SizedBox(height: 10),




              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDashboardCard(
                    title: 'Total Samples',
                    value: '120',
                    icon: Icons.analytics,
                    gradientColors: [Colors.lightBlueAccent,Colors.blue],  // Example gradient colors

                  ),
                  _buildDashboardCard(
                    title: 'Pending Tests',
                    value: '15',
                    icon: Icons.hourglass_empty,
                    gradientColors: [Color(0xFFFCE889), Color(0xFFFFAA00)],  // Example gradient colors
                  ),
                  _buildDashboardCard(
                    title: 'Completed Tests',
                    value: '105',
                    icon: Icons.check_circle,
                    gradientColors: [ Colors.lightGreen,Colors.green],  // Example gradient colors
                  ),
                  _buildDashboardCard(
                    title: 'Retesting',
                    value: '5',
                    icon: Icons.refresh,
                    gradientColors: [Colors.redAccent,Colors.red],  // Example gradient colors
                  )

                ],
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Show the LocationSelectionScreen as a dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        double screenHeight = MediaQuery.of(context).size.height;
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(10), // Adjust the padding to reduce space
                          content: Container(
                            color: Colors.white,
                            height: screenHeight * 0.8,
                            width: screenHeight * 0.4, // Set a fixed height for the content
                            child: Locationscreen(), // Replace with your widget
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0468B1),
                    textStyle: TextStyle(fontSize: 16),
                    minimumSize: Size(300, 50), // Set a minimum width (200) and height (50)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ensures the button adjusts its size based on content
                    children: [
                      Icon(
                        Icons.add, // Plus symbol icon
                        color: Colors.white, // Match text color
                        size: 18, // Adjust the size as needed
                      ),
                      SizedBox(width: 8), // Add spacing between icon and text
                      Text(
                        'Add Sample',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradientColors,  // Gradient colors as List
  }) {
    return Container(
      padding: EdgeInsets.all(5),
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
            offset: Offset(0, 4),
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
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  String getToken(){
    String? token = _localStorage.getString('token') ?? '';
    print("token-------------- $token");
    return token;
  }
}

