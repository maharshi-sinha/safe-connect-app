import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:safe_connect/bottomNavBar.dart';
import 'package:safe_connect/screens/QrRegistrationScreen/qrCar.dart';
import 'package:lottie/lottie.dart';
import 'package:safe_connect/screens/QrRegistrationScreen/qrKey.dart';

class keyQR extends StatelessWidget {
  const keyQR({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => bottomNavigationBar()));
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ))),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Container(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Key',
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                        TextSpan(
                          text: ' Registration',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 20.0,
                            color: Color(0xFFFFB13D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: OverflowBox(
                  minHeight: 500,
                  maxHeight: 500,
                  child: Lottie.asset(
                    'assets/images/carLottie.json',
                    repeat: true,
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    'How to use ?',
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 20.0,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Container(
                    child: RichText(
                      text: TextSpan(
                        text:
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 15.0,
                          color: Colors.white38,
                        ),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => const KeyRegistration());
          },
          label: Text(
            "Register Here",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          isExtended: true,
          backgroundColor: const Color(0xFFFFB13D),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.black,
    );
  }
}
