import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/utils/Appcolor.dart';
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
                        SizedBox(
                          height: 30,
                        ),
                        Card(
                          elevation: 0,
                          color: Colors.white.withOpacity(0.8),
                          child: SizedBox(
                            width: double.infinity,
                            child: Container(
                              margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  buildHeader(),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Center(
                                    child: Text(
                                      'Departmental Official',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Appcolor.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Mobile Number / Username ',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        hintText: "Enter Mobile Number / Username",
                                        hintStyle: const TextStyle(fontSize: 16),
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        hintText: "Enter password",
                                        hintStyle: const TextStyle(fontSize: 16),
                                        suffixIcon: IconButton(
                                          icon: Icon(provider.isShownPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed: () {
                                            provider.togglePasswordVisibility();
                                          },
                                        ),
                                      ),
                                      controller: passwordController,
                                      keyboardType: TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.next,
                                      obscureText: !provider.isShownPassword,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 90,
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(left: 5),
                                          margin: const EdgeInsets.only(
                                              left: 0, right: 50),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                BorderRadius.circular(4)),
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 20),
                                            child: Center(
                                              child: Text(
                                                '${provider.randomOne}' +
                                                    " + " +
                                                    '${provider.randomTwo} =  ?',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.transparent,
                                            child: IconButton(
                                                color: Colors.black,
                                                onPressed: () {
                                                  provider.generateCaptcha();
                                                },
                                                icon: Center(
                                                    child: Image.asset(
                                                      "assets/ddd.png",
                                                      scale: 4,
                                                    ))),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        hintText: "Enter Captcha",
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      controller: captchaController,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (validateLoginInput(provider)) {
                                            provider.loginUser(
                                              phoneController.text,
                                              passwordController.text,
                                              "4",
                                                  () {
                                                // Success: Navigate to Dashboard or Home Screen
                                                print('sucess login');
                                                Navigator.pushReplacementNamed(context, '/dashboard');
                                              }, (errorMessage) {
                                                // Failure: Show Snackbar with error message
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(errorMessage)),
                                                );
                                              },
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      provider.errorMsg)),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Appcolor.btncolor),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Appcolor.white, fontSize: 18),
                                        )),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                        height: 60,
                                        width: 100,
                                        child: Image.asset("assets/nicone.png")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Loading Overlay
                  if (provider.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5), // Background opacity
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
      children: [
        Image.asset(
          'assets/appjalicon.png',
          width: 60,
          height: 60,
        ),
        const SizedBox(
          width: 10,
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jal Jeevan Mission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Appcolor.txtColor,
                ),
                overflow:
                    TextOverflow.ellipsis, // Prevents text from overflowing
              ),
              Text(
                'Water Quality Management Information System',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(JJM-WQMIS)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
