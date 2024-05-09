import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:safe_connect/screens/OtpScreen/otpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  bool _isButtonClicked = false;
  bool _isLoading = false;
  TextEditingController _mobileNumberController = TextEditingController();

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    String formattedPhoneNumber = '+91$phoneNumber';

    setState(() {
      _isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        Get.to(() => OtpScreen(
              mobileNumber: formattedPhoneNumber,
              verificationId: verificationId,
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Stack(
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.6,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: constraints.maxHeight * 0.1,
                            left: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: Color(0xffFFB13D),
                                    fontSize: 21,
                                    fontFamily: "cirka",
                                  ),
                                  child: Text(
                                    "Membership Application",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontFamily: "gilroy",
                                  ),
                                  child: Text(
                                    "Tell us your mobile number",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.4,
                                child: OverflowBox(
                                  minHeight: constraints.maxHeight * 0.4,
                                  maxHeight: constraints.maxHeight * 0.4,
                                  child: Lottie.asset(
                                    'assets/images/carLottie.json',
                                    repeat: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: constraints.maxWidth * 0.9,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: _mobileNumberController,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: "gilroy",
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        counterText: null,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "gilroy",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                              _isButtonClicked = _isChecked;
                            });
                          },
                          focusColor: Colors.white,
                          activeColor: Colors.black,
                        ),
                        Text(
                          'I agree to the terms and conditions',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "gilroy",
                            color: _isChecked
                                ? Color(0xffFFB13D)
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: constraints.maxWidth * 0.9,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isChecked
                          ? () {
                              if (_mobileNumberController.text.isNotEmpty) {
                                _verifyPhoneNumber(
                                    _mobileNumberController.text);
                              }
                            }
                          : null,
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "gilroy",
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                          (states) {
                            if (_isChecked &&
                                !states.contains(MaterialState.disabled)) {
                              return Color(0xffFFB13D);
                            }
                            return Colors.grey.withOpacity(
                                0.5); // Changed to blue when checkbox is not checked
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_isLoading)
                    Container(
                      height: constraints.maxHeight * 0.4,
                      color: Colors.transparent,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
