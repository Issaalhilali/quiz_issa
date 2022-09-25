import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:quizu/const/colors.dart';
import 'package:quizu/const/padd.dart';
import 'package:quizu/repository/auth/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController controller = TextEditingController();
  Repository repository = Repository();

  bool _isLoading = false;
  @override
  void initState() {
    // logi();
    super.initState();
  }

  login() async {
    setState(() {
      _isLoading = true;
    });
    if (controller.text.isNotEmpty) {
      await repository.login(context, controller.text.trim());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: purple,
        body: SafeArea(
            child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [purple, deepPurple],
          )),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.network(
                  //   'https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png',
                  //   fit: BoxFit.cover,
                  //   width: 280,
                  // ),
                  padd20,
                  padd20,
                  FadeInDown(
                    child: const Text(
                      'QUIZ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: "quick_semi",
                          color: lightgrey),
                    ),
                  ),
                  padd20,
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Enter your phone number to continu, we will send you OTP to verifiy.',
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: lightgrey,
                          fontFamily: "quick_semi",
                        ),
                      ),
                    ),
                  ),
                  padd16,
                  FadeInDown(
                    delay: const Duration(milliseconds: 400),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.13)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color(0xffeeeeee),
                        //     blurRadius: 10,
                        //     offset: Offset(0, 4),
                        //   ),
                        // ],
                      ),
                      child: Stack(
                        children: [
                          InternationalPhoneNumberInput(
                            initialValue:
                                PhoneNumber(isoCode: 'SA', dialCode: ''),
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                            },
                            onInputValidated: (bool value) {
                              print(value);
                            },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            // autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle:
                                const TextStyle(color: Colors.black),
                            textFieldController: controller,
                            formatInput: false,
                            maxLength: 9,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            cursorColor: Colors.white.withOpacity(0.8),
                            inputDecoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(bottom: 15, left: 0),
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 16),
                            ),
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                            },
                          ),
                          Positioned(
                            left: 90,
                            top: 8,
                            bottom: 8,
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.black.withOpacity(0.13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // TextFormField(
                  //   controller: controller,
                  // ),
                  const SizedBox(
                    height: 100,
                  ),
                  FadeInDown(
                    delay: const Duration(milliseconds: 600),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () {
                        login();
                      },
                      color: lightgrey.withOpacity(0.8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: lightgrey,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "START",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "quick_semi",
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
