import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/utils/Appcolor.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:provider/provider.dart';

import '../../utils/AppStyles.dart';

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
                   style: AppStyles.appBarTitle,
                ),
                backgroundColor: Appcolor.btncolor,
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/header_bg.png'),
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
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildFormLabel('Mobile Number / Username'),
                                buildTextFormField(
                                  controller: phoneController,
                                  hint: 'Enter Mobile Number or Username',
                                  icon: Icons.person_outline,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                                SizedBox(height: 20),

                                buildFormLabel('Password'),
                                buildTextFormField(
                                  controller: passwordController,
                                  hint: 'Enter your password',
                                  icon: Icons.lock_outline,
                                  obscureText: !provider.isShownPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      provider.isShownPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.blueGrey,
                                    ),
                                    onPressed: provider.togglePasswordVisibility,
                                  ),
                                ),
                                SizedBox(height: 20),

                                buildFormLabel('Security Check'),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF1F3F4),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${provider.randomOne} + ${provider.randomTwo} = ?',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'OpenSans',),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: provider.generateCaptcha,
                                      borderRadius: BorderRadius.circular(30),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.blue.shade50,
                                        child: Icon(Icons.refresh, color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16),

                                buildTextFormField(
                                  controller: captchaController,
                                  hint: 'Enter result',
                                  icon: Icons.verified_user,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 30),

                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (validateLoginInput(provider)) {
                                        provider.loginUser(
                                          phoneController.text,
                                          passwordController.text, 1,
                                              () {
                                            provider.fetchLocation();
                                            if(provider.loginResponse?.roleId==4){
                                              Navigator.pushReplacementNamed(
                                                  context, AppConstants.navigateToDashboardScreen);
                                            }else if(provider.loginResponse?.roleId==8){
                                              Navigator.pushReplacementNamed(
                                                  context, AppConstants.navigateToDwsmDashboard);
                                            }
                                          },
                                              (errorMessage) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(errorMessage)));
                                          },
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(provider.errorMsg)));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Appcolor.btncolor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14)),
                                      elevation: 4,
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color:Colors.white,
                                        fontSize: 17, fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset("assets/icons/nicone.png", height: 40),
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
    provider.errorMsg = (phone.isNotEmpty && phone.length == 10 && RegExp(r'^[0-9]{10}$').hasMatch(phone))
        ? (password.isNotEmpty ? (captcha.isNotEmpty && enteredCaptcha == provider.captchResult // Compare as int
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
          'assets/icons/appjalicon.png',
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
                  fontWeight: FontWeight.w700, fontFamily: 'OpenSans',
                  color: Appcolor.txtColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Prevents text overflow
              ),
              SizedBox(height: 3), // Minor spacing for readability
              Text(
                'Water Quality Management Information System',
                style: TextStyle(
                  fontSize: 12, fontFamily: 'OpenSans',
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
                  fontWeight: FontWeight.w600, fontFamily: 'OpenSans',
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
  Widget buildFormLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Color(0xFFF5F7FA),
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }



}
