import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jjm_wqmis/providers/authentication_provider.dart';
import 'package:jjm_wqmis/utils/Appcolor.dart';
import 'package:provider/provider.dart';

// Login Page
class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  bool isShownPassword = false;
  var random;
  var random1;
  var hashedPassword;
  var errorMsg;
  var HASHpassword;
  int RandomNumber = 0;
  int RandomNumber1 = 0;
  int addcaptcha = 0;
  int RandomNumbersalt = 0;

  @override
  void initState() {
    super.initState();
    random = generateRandomString(6);
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthenticationProvider(),
        child: Consumer<AuthenticationProvider>(builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: const Text(
                  'Login ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                backgroundColor: Appcolor.btncolor,
                elevation: 5,
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/header_bg.png'),
                    fit: BoxFit.fill,
                    scale: 3),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/header_bg.png'),
                            fit: BoxFit.fill,
                            scale: 4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(),
                          Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/header_bg.png'),
                                  fit: BoxFit.fill,
                                  scale: 3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.white.withOpacity(0.8),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Jal Jeevan Mission',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Appcolor.txtColor,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Prevents text from overflowing
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
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              const Center(
                                child: Text(
                                  'Departmental Official',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Appcolor.grey),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Mobile Number / Username ',
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
                                    suffixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShownPassword = !isShownPassword;
                                          });
                                        },
                                        child: Icon(
                                          isShownPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                  ),
                                  controller: passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.next,
                                  obscureText: !isShownPassword,
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
                                            '$RandomNumber' +
                                                " + " +
                                                '$RandomNumber1 =  ?',
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
                                          setState(() {
                                            random = generateRandomString(6);
                                          });
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
                              const SizedBox(
                                height: 40,
                              ),
                              Consumer<AuthenticationProvider>(
                                  builder: (context, authProvider, child) {
                                return Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (validateLoginInput(
                                              correctCaptcha: random)) {
                                            authProvider.loginUser(
                                                phoneController.text,
                                                passwordController.text);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text('$errorMsg')));
                                            print(errorMsg);
                                          }
                                        },
                                        child: Text('Login')),
                                  ),
                                );
                              }),
                              Container(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                      height: 60,
                                      width: 100,
                                      child: Image.asset("assets/nicone.png")),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  int generateRandomString(int len) {
    int max = 15;
    RandomNumber = Random().nextInt(max);
    RandomNumber1 = Random().nextInt(max);
    addcaptcha = RandomNumber + RandomNumber1;
    RandomNumbersalt = Random().nextInt(max);

    return addcaptcha;
  }

  bool validateLoginInput({
    int correctCaptcha = 0, // Set your captcha value here
  }) {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String captcha = captchaController.text.trim();

    int? enteredCaptcha = int.tryParse(captcha);
    // Using a single if-else statement
    errorMsg = (phone.isNotEmpty &&
            phone.length == 10 &&
            RegExp(r'^[0-9]{10}$').hasMatch(phone))
        ? (password.isNotEmpty
            ? (captcha.isNotEmpty &&
                    enteredCaptcha == correctCaptcha // Compare as int
                ? ""
                : "Please Enter Correct Captcha")
            : "Please Enter Password")
        : "Please Enter Valid Mobile Number";

    return errorMsg.isEmpty;
  }
}
