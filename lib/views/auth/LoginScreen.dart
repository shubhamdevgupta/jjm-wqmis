import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/utils/Appcolor.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:provider/provider.dart';

// Login Page
class Loginscreen extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginscreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthenticationProvider(),
        child: Consumer<AuthenticationProvider>(
            builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  'Login ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                backgroundColor: Appcolor.btncolor,
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/header_bg.png'),
                    fit: BoxFit.fill,
                    scale: 3),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: buildHeader(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: Colors.white.withOpacity(0.95),
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Center(
                                  child: Text(
                                    'Departmental Official',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Appcolor.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),

                                // Mobile Number Field
                                Text('Mobile Number / Username',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: phoneController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone, color: Colors.blueGrey),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: "Enter Mobile Number / Username",
                                  ),
                                  keyboardType: TextInputType.number,
                                ),

                                SizedBox(height: 15),

                                // Password Field
                                Text('Password',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: !provider.isShownPassword,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: "Enter password",
                                    suffixIcon: IconButton(
                                      icon: Icon(provider.isShownPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      color: Colors.blueGrey,
                                      onPressed: provider.togglePasswordVisibility,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),

                                // CAPTCHA Section
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${provider.randomOne} + ${provider.randomTwo} = ?',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: provider.generateCaptcha,
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.refresh, color: Colors.blueGrey, size: 24),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),

                                // CAPTCHA Input
                                TextFormField(
                                  controller: captchaController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.security, color: Colors.blueGrey),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: "Enter Captcha",
                                  ),
                                  keyboardType: TextInputType.number,
                                ),

                                SizedBox(height: 20),

                                // Login Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (validateLoginInput(provider)) {
                                        provider.loginUser(
                                          phoneController.text,
                                          passwordController.text,
                                          "4",
                                              () {
                                            print('Successful login');
                                         //   provider.loadDashboardData(roleId, userId, stateId)
                                            Navigator.pushReplacementNamed(context, AppConstants.navigateToDashboard);
                                          },
                                              (errorMessage) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(errorMessage)),
                                            );
                                          },
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(provider.errorMsg)),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Appcolor.btncolor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset("assets/nicone.png", height: 45),
                                ),
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                  // Loading Overlay
                  if (provider.isLoading)
                  LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                ],
              ),
            ),
          );
        }));
  }

  bool validateLoginInput(AuthenticationProvider provider) {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String captcha = captchaController.text.trim();

    int? enteredCaptcha = int.tryParse(captcha);
    // Using a single if-else statement
    provider.errorMsg = (phone.isNotEmpty &&
            phone.length == 10 &&
            RegExp(r'^[0-9]{10}$').hasMatch(phone))
        ? (password.isNotEmpty
            ? (captcha.isNotEmpty &&
                    enteredCaptcha == provider.captchResult // Compare as int
                ? ""
                : "Please Enter Correct Captcha")
            : "Please Enter Password")
        : "Please Enter Valid Mobile Number";

    return provider.errorMsg.isEmpty;
  }

  Widget buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo
        Image.asset(
          'assets/appjalicon.png',
          width: 55,
          height: 65,
        ),
        SizedBox(width: 12), // Adjusted spacing for a balanced layout

        // Title & Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jal Jeevan Mission',
                style: TextStyle(
                  fontSize: 18, // Slightly reduced for better balance
                  fontWeight: FontWeight.w700,
                  color: Appcolor.txtColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Prevents text overflow
              ),
              SizedBox(height: 3), // Minor spacing for readability
              Text(
                'Water Quality Management Information System',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800], // Softer color for better contrast
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                '(JJM-WQMIS)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700], // Slightly softer color
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

}
